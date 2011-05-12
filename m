Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab1ELFle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 01:41:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55724 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1ELFld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 01:41:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QTJSvW4IUa6n8QuwS8hizZWagXYTAKg/sJuh0EtDlRxLyh6umnCdFobHqgvCv1k3u0
         NuKVGtQ6QaNr3rg4Za0/aDoe15uc1zSbwQOhVffBhfjwDBS3vd2+X+N2D2OQ605NS0Yb
         Ocy2O5gHaEVA6lLMuNscmLxSWw8Zbo3k9FOBU=
MIME-Version: 1.0
In-Reply-To: <20110512053109.GA26926@kroah.com>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<20110511211401.GC4893@kroah.com>
	<BANLkTikjf9ZAthr3jTUkoUKGJt2UGS73Cg@mail.gmail.com>
	<20110511231843.GC7362@kroah.com>
	<BANLkTim_WZdmE31qjChg8u0M8RKzez3fqg@mail.gmail.com>
	<20110512053109.GA26926@kroah.com>
Date: Wed, 11 May 2011 22:41:31 -0700
Message-ID: <BANLkTikAVC6vR0SEu86fQ-9mwn9853Qgbg@mail.gmail.com>
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
From: matt mooney <mfmooney@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:31 PM, Greg KH <greg@kroah.com> wrote:
> On Wed, May 11, 2011 at 08:24:12PM -0700, matt mooney wrote:
>> > We add it to drivers/staging/usbip/userspace/ and build it like the perf
>> > code is built.
>>
>> Okay, I will add the code as is to userspace/ except for the module
>> name changes of course. Now I am suppose to add this to
>> scripts/packages/Makefile or is there another way for staging?
>
> I really don't know as I haven't looked at that part of the build system
> in years.  If you have problems, I will be glad to help out, but give it
> a try first :)

Not a problem; I just wanted to make sure. I actually sent in a patch
to fix a bug with building perf earlier today so hopefully Michal
picks it up quickly.

I resent two patches that don't rely on my pr_*() commit in a new
thread. The other patches will be resent once I get the dev_*()
changes in. But I will send in the userspace utility patch asap
although I might have created a conflict with the perf patch I sent in
earlier.

Thanks,
matt

-- 
GPG-Key: 9AFE00EA
