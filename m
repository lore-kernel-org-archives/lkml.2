Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1EQV7c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:59:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37181 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab1EQV7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=h619zTub5xKTtHQptULnTbro05zW6EMKF+SCnolQLhzPECgEJrE48Ov9U0ktqPfQHl
         zg0AIc2a6mzYziVmtrZUWgXV8357sG8h5K2xzpG74pIusDDGC1ZFNxaJCC4X+bB115nI
         H5M2l9uGfLN+y6KWnex1xsjAt73GpD2YEUVL4=
MIME-Version: 1.0
In-Reply-To: <20110517212122.GA13484@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
	<5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
	<20110517202300.GA7981@kroah.com>
	<BANLkTimCEFEVmdQM9J1=0QRE2NFcim6fAw@mail.gmail.com>
	<20110517212122.GA13484@kroah.com>
Date: Tue, 17 May 2011 14:59:29 -0700
Message-ID: <BANLkTimZ8gvVaRz3HPqdJnOwAz2K6iuJSA@mail.gmail.com>
Subject: Re: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 2:21 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, May 17, 2011 at 02:13:01PM -0700, matt mooney wrote:
>> On Tue, May 17, 2011 at 1:23 PM, Greg KH <greg@kroah.com> wrote:
>> > On Sat, May 14, 2011 at 03:55:20AM -0700, matt mooney wrote:
>> >> From: matt mooney <mfm@muteddisk.com>
>> >>
>> >> Add usbip-src-pkg target to generate a tarball of the userspace source.
>> >>
>> >> Signed-off-by: matt mooney <mfm@muteddisk.com>
>> >> ---
>> >>  scripts/package/Makefile |   15 ++++++++++++++-
>> >
>> > Is this really needed at this point in time?  I'd prefer to wait on it
>> > before we get this code cleaned up a bit better if you don't mind.
>>
>> Oh yeah, of course. I only added it because I thought you wanted me to
>> add it now.
>
> For some reason I thought it would be more, but there really isn't a way
> to build the userspace code from the main root of the kernel tree is
> there?

I do not believe there is. Since `make ...' starts the Kbuild system,
Kbuild would have to support this otherwise we would have to
circumvent the build system. And the closest thing to some kind of
support I could find was in scripts/Makefile.host, but it says it is
for binaries used during the kernel compilation process. I think this
set of userspace utilities is further complicated by its use of
autotools.

My use of "circumvent the build system" may be a bit harsh. I don't
think there is anything wrong with running a parameterized instance of
make within a target, but the short answer would be that this problem
does not seem to have been generalized in Kbuild yet.

-matt

-- 
GPG-Key: 9AFE00EA
