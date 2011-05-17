Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363Ab1EQVNF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 17:13:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42931 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296Ab1EQVNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 17:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=YBbqRaj8mR3o4LIfyMNbpleqtToQj6/dFCi331oO3J7cTak4H58YhOjqXnoBlh3i8c
         MLfQlqmITZIsfs6eCLfWU14/XWaLPFyyiBq7Pq172ENr3BcFeSeDEJP7Lt6j6vttSB78
         nzY686PXka/YYPdpS8IYgtDfWg0NcqoTA+W44=
MIME-Version: 1.0
In-Reply-To: <20110517202300.GA7981@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
	<5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
	<20110517202300.GA7981@kroah.com>
Date: Tue, 17 May 2011 14:13:01 -0700
Message-ID: <BANLkTimCEFEVmdQM9J1=0QRE2NFcim6fAw@mail.gmail.com>
Subject: Re: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 17, 2011 at 1:23 PM, Greg KH <greg@kroah.com> wrote:
> On Sat, May 14, 2011 at 03:55:20AM -0700, matt mooney wrote:
>> From: matt mooney <mfm@muteddisk.com>
>>
>> Add usbip-src-pkg target to generate a tarball of the userspace source.
>>
>> Signed-off-by: matt mooney <mfm@muteddisk.com>
>> ---
>>  scripts/package/Makefile |   15 ++++++++++++++-
>
> Is this really needed at this point in time?  I'd prefer to wait on it
> before we get this code cleaned up a bit better if you don't mind.

Oh yeah, of course. I only added it because I thought you wanted me to
add it now.

-- 
GPG-Key: 9AFE00EA
