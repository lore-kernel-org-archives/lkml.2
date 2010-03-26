Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0CZUgw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 16:36:52 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:54576 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab0CZUgu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 16:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=GaHmzEat/i5DVMe/5qIAD5rdCSVZnOO5NitRFLvEFdy/TFFAncFh5uNtuFLFrk8dXJ
         ywNSMfyWzAIRkW2nxS26xrxxJQEHua9lS4nbK0yEyHWxpUx/aHmPodMgR0pfKh5aTBR4
         6oHIgSTqDhainWBM19JWHw2omYloHkotgnVzg=
MIME-Version: 1.0
In-Reply-To: <201003152038.47124.rjw@sisk.pl>
References: <alpine.LFD.2.00.1003142155470.19244@sony>
	 <b170af451003142310i3fe61282pb6536f6d2000c9c8@mail.gmail.com>
	 <201003152038.47124.rjw@sisk.pl>
Date: Fri, 26 Mar 2010 21:36:48 +0100
Message-ID: <b170af451003261336u44e6e4b9qe9bd6e6b6909256e@mail.gmail.com>
Subject: Re: ACPI patches for Linux-2.6.34-rc1
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, Len Brown <len.brown@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/15 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 15 March 2010, Rafał Miłecki wrote:
>> 2010/3/15 Len Brown <lenb@kernel.org>:
>> > Hi Linus,
>> >
>> > please pull from:
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>> >
>> > Here is why three things included in this request
>> > look somewhat "merge-windo-ish".
>>
>> Len, you seem to hardly ignore
>> [PATCH] ACPI / PM: Move ACPI video resume to a PM notifier
>>
>> AFAIK this didn't hit rc1, is not included in this patchset and we
>> couldn't get any response from you in this thread.
>
> I wanted to mention that too.  Here's the patchwork link:
>
> http://patchwork.kernel.org/patch/83479/
>
> Len, if you want me to push it myself, I can do that.

I do not see that patch in changelogs for rc1 or rc2 of .34. Can you
submit this patch some other way Rafael?

-- 
Rafał
