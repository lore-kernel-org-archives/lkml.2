Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab0FGDEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 23:04:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37821 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755765Ab0FGDEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 23:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sjAqzws5/eWkotIIrpRmgeseIilE/kRZ1iqIPseq6a6OZq+eGIVjW+y4Y7TiB2nxbG
         ykFaVCdYl3yQ6MJAB6TKAO2lcWPRjG49oIbo9r9+J22XAaPNfd3Vi7JPdiTdnDj5QOEk
         58H+D4cz2cKseEYesH7G0spAfcZynORSEAj+k=
MIME-Version: 1.0
In-Reply-To: <AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<4C0BC35C.8070003@kernel.org>
	<4C0BC45A.6080104@gmail.com>
	<AANLkTinWB1M3uz5We566e2-UzwFsJuDi3rDAihgU5jCj@mail.gmail.com>
	<AANLkTilDH891zRB_lv4OYEAlAKzHMTIGyDmbVm7I07xk@mail.gmail.com>
Date: Mon, 7 Jun 2010 05:04:30 +0200
Message-ID: <AANLkTilHUsw_xOHecwEHNmk94kgSZuJq7h1iPJYMkhKK@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alex Deucher <alexdeucher@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 4:33 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 2:25 AM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
>> On Sun, Jun 6, 2010 at 5:52 PM, Tejun Heo <htejun@gmail.com> wrote:
>>> On 06/06/2010 05:48 PM, Tejun Heo wrote:
>>>> Can you please try w/o KMS just in case?
>>
>> 2 out of 2 attempts without KMS worked without any OOPS.
>> Sorry to have bother you with this, it now really looks KMS related.
>>
>>> Also, does it always crash the same way?
>
> Just an initial guess does the vt.c patch in thread
>
> "Re: BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)"
>
> help any?
>
> I can't think off hand of any KMS patch that could have caused it
> (though there were quite a few).

It appears to be helping here; -rc2+vt.c patch, no oops on startx.

Thanks,

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
