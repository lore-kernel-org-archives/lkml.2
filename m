Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0KXIlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:41:19 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39976 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385Ab0KXIlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:41:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=WO8Zz3OOkBondWaEqcCsLj+yLCUsphxfc4urHoeMOtqEEZwfwX6InlPfepJB8a3o1U
         zvJ5qQUqmen8r2OCWwzFL8podu49R7xGaXY7sF0gpByg1YrAs86kpWFFHnTa5T92otmT
         Qf4fNzpAXCRX9i6iNDrgrHy3ofvlS0DvReDQ0=
MIME-Version: 1.0
In-Reply-To: <AANLkTinfsjy9GzDg1eHx+mFc4VabCZ2jk85JodFqRnEE@mail.gmail.com>
References: <20100831083844.043619334@linux.vnet.ibm.com> <AANLkTikCLHh5Uz-DRq9ws78We+SwCAqdurA6HfuJh-8Y@mail.gmail.com>
 <20101018103729.GA4122@linux.vnet.ibm.com> <AANLkTikKJ25L=6b2resz+0SAg7ZYL5j=rHG7Lg4kFbwd@mail.gmail.com>
 <20101019110801.GA4128@linux.vnet.ibm.com> <AANLkTimLi8BYy_u8NhD15s=+iiODzuG1H_CgZ-cd7jep@mail.gmail.com>
 <20101019213112.GA11432@merkur.ravnborg.org> <AANLkTike6UQVWKSz-Njs5Rps690EHeResH3V+aSM+qdO@mail.gmail.com>
 <AANLkTimn8R-qde8FH_cNa4JPcR2F=mkUAQhPVT-hOBhn@mail.gmail.com>
 <4CC8ABC7.5030003@suse.cz> <20101028203542.GA30879@merkur.ravnborg.org>
 <4CC9E8C7.60306@suse.cz> <AANLkTinfsjy9GzDg1eHx+mFc4VabCZ2jk85JodFqRnEE@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Wed, 24 Nov 2010 03:40:51 -0500
Message-ID: <AANLkTimDUnaQ+Nax5Xz_TFmzPpj-20w7LOknL_WCKDdt@mail.gmail.com>
Subject: Re: [PATCH] initramfs: Fix build break on symbol-prefixed archs
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
        Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>, tabbott@ksplice.com,
        vda.linux@googlemail.com, hpa@linux.intel.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        heiko.carstens@de.ibm.com, schwidefsky@de.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 18:17, Mike Frysinger wrote:
> On Thu, Oct 28, 2010 at 17:19, Michal Marek wrote:
>> On 28.10.2010 22:35, Sam Ravnborg wrote:
>>> On Thu, Oct 28, 2010 at 12:46:31AM +0200, Michal Marek wrote:
>>>> On 27.10.2010 20:23, Mike Frysinger wrote:
>>>>> can we get this change dropped from linux-next until someone gets a
>>>>> chance to fix it ?
>>>>
>>>> Sorry I missed this thread. So your last patch
>>>> (http://lkml.org/lkml/2010/10/19/488) did fix the Blackfin build
>>>> failure? Can you submit it with a proper Signed-off-by and changelog?
>>>
>>> Did you see the patch I posted in: http://lkml.org/lkml/2010/10/19/534
>>>
>>> The one that fix up the cppflags usage.
>>>
>>> I think this will solve the issue with blackfin nicely - and
>>> make use of cppflags more as expected.
>>
>> As Mike noted - your patch does not strip the double quotes. And Mike's
>> patch is really minimal, it just adds the SYMBOL_PREFIX definition to
>> _a_flags. I'll look at your patch after this merge window.
>
> why am i seeing __initramfs_size failures in mainline now ?

ping ... it looks like no one merged the VMLINUX_SYMBOL() changes in
usr/initramfs_data.S proposed by Hendrik
-mike
