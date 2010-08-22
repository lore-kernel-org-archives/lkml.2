Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab0HVWKL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 18:10:11 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51129 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab0HVWKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 18:10:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AUGT3EzeSN5b1hOi9tnJEsdhFmzSEQUD0d0jIXHW3UGbaL0zZpZ8/dSn7b+boU9Z0m
         JTJS84hyGcAjkACPQGFZobStYPTyxerTI/IAQnNKF6vJ2x6QwOEFAcOxztWPPzKlofN2
         ocBJtxu4x+pCM8iK02UI7lTVa3sTdd9Y/dTTQ=
MIME-Version: 1.0
In-Reply-To: <1282423128.3015.35.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	<1282077040.16098.47.camel@mulgrave.site>
	<4C6C1DC1.8090208@vlnb.net>
	<1282164188.10878.22.camel@mulgrave.site>
	<4C702030.2070306@vlnb.net>
	<1282423128.3015.35.camel@mulgrave.site>
Date: Sun, 22 Aug 2010 18:10:08 -0400
Message-ID: <AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Gennadiy Nerubayev <parakie@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 4:38 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Sat, 2010-08-21 at 22:51 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley, on 08/19/2010 12:43 AM wrote:
>> >>>> 1. What don't you like in the transition path for users from STGT to
>> >>>> SCST, which I proposed:
>> >>>>
>> >>>>     - The only people which would be affected by replacing of STGT by SCST
>> >>>> would be users of ibmvstgt. Other STGT users would not notice it at all.
>> >>>> Thus, we should update ibmvstgt for SCST. If ibmvstgt updated for SCST,
>> >>>> the update for its users would be just writing of a simple scstadmin's
>> >>>> config file.
>> >>>>
>> >>>>     - STGT doesn't have backend drivers, which SCST doesn't have, so
>> >>>> there's nothing to worry here. At max, AIO support should be added to
>> >>>> fileio_tgt.
>> >>>>
>> >>>>     - STGT user space targets can use SCST backend via scst_local module.
>> >>>> Scst_local module is ready and work very well.
>> >>>>
>> >>>> The result would be very clear without any obsolete mess.
>> >>>
>> >>> So does that get us up to being a drop in replacement?  I think you're
>> >>> saying that even with all of this, at least the VSCSI part will need
>> >>> updating, so the answer seems to be "no".
>> >>
>> >> Sorry, I can't understand, "no" for which? For the whole transition
>> >> path, or just until there is a patch for ibmvstgt to become ibmvscst?
>> >
>> > No to the question "does that get us up to being a drop in replacement
>> > [for STGT]?"
>>
>> I'm sorry again, I did my best, but still can't understand. What you
>> wrote looks for me too ambiguous. My English must be too bad..
>>
>> Could elaborate more for what the "no" is, please? What don't you like
>> in the plan I suggested?
>
> No it isn't a plan that gives us a drop in replacement for STGT.  I
> didn't say migration path to random userspace target, I said reuse of
> existing code.

Hi James,

(disclaimer: I'm a hoi polloi SCST user)

I'm not sure if I understand why there is a need for a replacement
target to reuse existing code, and would definitely appreciate a brief
explanation or a pointer to an earlier one. But even that aside, I'm
curious if the criteria for what a replacement target must have for
(at least potential) inclusion into the kernel were ever clearly
outlined in the past. If they were, then there probably would have
been things like interested contenders, deadlines, feature
comparisons, code reviews, and so on, right?

Now, I can't claim familiarity with the kernel development process, or
any "political" workings in it. The aforementioned however would seem
like a logical way of doing this since I assume that for whatever
reason, there is a strict limit to only one generic SCSI target in the
Linux kernel, and obviously as per this thread the current one is
being replaced.

Please correct/rebuke me as needed :)

Thanks,

-Gennadiy
