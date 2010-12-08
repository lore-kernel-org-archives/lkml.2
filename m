Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0LHBpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:45:44 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53549 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758128Ab0LHBpj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:45:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=D+zIyBcQ5FLXJtWGE15y4hq1KQSlRP2x/qFGGqZTRzvTnBqZP7HvGNf8a+/LME/0nt
         ms/aiPRVdTBEASf8C6FWy7TqyfqqL7r3fgY56XO5ruWvFnN/vbwXc/cihgpL2KHfIbsA
         KH1py80UmWgT+k6Eh5iVvIYS9TuRcvSOLNK34=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1012070911380.13430@utopia.booyaka.com>
References: <alpine.DEB.2.00.1012061734590.13430@utopia.booyaka.com>
 <AANLkTimXPFROMQ_fF4Od-jw3aDY0WZQgc=x14=VcFM3d@mail.gmail.com>
 <alpine.DEB.2.00.1012061839170.13430@utopia.booyaka.com> <20101207094841.GA4772@sortiz-mobl>
 <alpine.DEB.2.00.1012070911380.13430@utopia.booyaka.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 8 Dec 2010 09:45:11 +0800
X-Google-Sender-Auth: dD4u3KizBNiGs6VxU2Hz2364RDU
Message-ID: <AANLkTim03xqbrkhyN1oR+ksoEuC-utD58h_5A3psRiUX@mail.gmail.com>
Subject: Re: [PATCH] MFD: TWL/TPS: fix twl_probe section mismatch warning in mfd/twl-core.c
To: Paul Walmsley <paul@pwsan.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 8, 2010 at 12:12 AM, Paul Walmsley <paul@pwsan.com> wrote:
> Hello Samuel,
>
> On Tue, 7 Dec 2010, Samuel Ortiz wrote:
>
>> On Mon, Dec 06, 2010 at 06:40:38PM -0700, Paul Walmsley wrote:
>> >
>> > That's fine with me.  Samuel et al, Bryan's already done a patch
>> > for this stuff:
>> >
>> > https://patchwork.kernel.org/patch/367011/
>> >
>> > so we should use that instead, if you're happy with it.  Samuel, maybe we
>> > could get an ack from you on it?
>> The twl driver is not OMAP specific, so this should be a separate patch thatI
>> will merge to my mfd tree.
>> If you really insist in pushing this through Tony's tree, then please add my
>> Acked-by for the mfd part.
>
> I don't insist at all :-)
>
> Bryan, maybe split your patch into a mach-omap2 patch and a TWL
> driver-specific patch, and send the latter for Samuel?
>
>

No problem. I'll do soon.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
