Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913Ab0ESLTV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 07:19:21 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36638 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711Ab0ESLTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 07:19:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UZ6Mm69P3EcyYtnis8p9MRgi+DSFnPfrAJvslxjdhyFRw2aMqNKdyA4tqAwbCBCRrC
         QzNDL3Jif6csKP0atubVR+c42y2frpR+YQ+nQlmdptJ9ExZSontsCRCSctuD7J9oqikB
         nGBWTaTH7xOtb5Ae1imnlktstwnnghDUfNuc8=
MIME-Version: 1.0
In-Reply-To: <20100519105305.54804b57@lxorguk.ukuu.org.uk>
References: <201005051757.o45HvPmY005954@amcc.com>
	 <AANLkTiljlMJKimdT-ptwXrMMBhSxFuPdVdyUuKJ8BZve@mail.gmail.com>
	 <20100519105305.54804b57@lxorguk.ukuu.org.uk>
Date: Wed, 19 May 2010 20:19:18 +0900
Message-ID: <AANLkTikJVJPn6eG8YsM2tDJxxo49cuKdstmZRdNkV1Te@mail.gmail.com>
Subject: Re: [PATCH]460EX on-chip SATA driver <Kernel 2.6.33> < resubmission >
From: Jassi Brar <jassisinghbrar@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Rupjyoti Sarmah <rsarmah@amcc.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com, sr@denx.de,
       linuxppc-dev@ozlabs.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 6:53 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Wed, 19 May 2010 10:49:59 +0900
> Jassi Brar <jassisinghbrar@gmail.com> wrote:
>
>> On Thu, May 6, 2010 at 2:57 AM, Rupjyoti Sarmah <rsarmah@amcc.com> wrote:
>> > This patch enables the on-chip DWC SATA controller of the AppliedMicro processor 460EX.
>>
>> The controller seems to be a thrid party IP (from Synopsys) in your
>> SoC and there are many chances the IP will appear in some other
>> SOCs too. This implementation doesn't seem to take care of that
>> scenario.
>
> I'd question if that is worth it seriously. At the point there are
> multiple users of the device you know what it will look like. Until then
> you neither know if the work is needed nor what will require abstracting.
Well, am to start writing driver for some dwc sata core in near
future, not sure of the
exact version because I've not yet had my hands on the specs.
Even if my version happens to be different, we don't wanna count on such odds.
So I believe it's worthwhile.

Btw, I presented two options and the author can always choose the
first one - rename
the driver as SoC specific. And in a way, I'd prefer that :)

> Lazy evaluation is good for code too ;)
Apart from increasing re-usability, that POV brings out neat code too.
