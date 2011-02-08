Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1BHKDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 05:03:54 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35358 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1BHKDx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 05:03:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=bYuh5uB8JEcG0ktfiEjqRrvq8ihKuQ7ho90mNACzeuEm2OAWUwysitFRNoHIavkh6L
         ju18kiv8ZQ643Z54yFZUfpa0ftRtRmK9mGOMVhrz1eRegVR16U804jrPpnKH2q7BYz3L
         P3hZcrq7rhgeQa2wh0xfZZaGuCXnG1SKg2KS8=
MIME-Version: 1.0
In-Reply-To: <4D511268.5040804@ladisch.de>
References: <AANLkTi=1wjdu3kT6nimU0fnZStG01a57D3O5Up+oJRdr@mail.gmail.com> <4D511268.5040804@ladisch.de>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 8 Feb 2011 21:03:33 +1100
Message-ID: <AANLkTik=DJV+E3BQwAc+3MfZiwB1WjjP-cD2U0A9_CPd@mail.gmail.com>
Subject: Re: I do not know if this is the correct place to ask about this but...
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2011 20:52, Clemens Ladisch <clemens@ladisch.de> wrote:
> dave b wrote:
>> I do not know if this is the correct place to ask about this but...
>>
>> [Hardware Error]:
>
> This is a hardware error that was detected by the kernel.
>
>> I have only seen the following output output twice
>>
>> ... Corrected error
>> ... L3 ECC data cache error.
>
> There was a wrong bit in your CPU's level 3 cache, but with the help of
> the redundant error correction bits, this was caught and corrected.

Yep I got that.

> (If possible, enable background scrubbing of the caches in the BIOS ECC
> settings to catch these errors earlier.)

Ok I will look into that.

> If this is an overclocked CPU or one with an unlocked core, you deserve
> what you got.  Otherwise, if this happens repeatedly, it indicates
> a hardware defect, and your warranty should cover this.

Ok fair enough.

Notes:
The cpu is not overclocked.
I forgot to list the hardware specifications:
cpu is a AMD Phenom(tm) II X6 1055T Processor
running on a ASUS  M4A88TD-M motherboard.
