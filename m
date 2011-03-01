Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab1CAXas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 18:30:48 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60472 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592Ab1CAXaq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 18:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Te1Y616g5rJQZ7Xp5yspbjszIfK2SmqjisPnDap8urLPPi8x/k9yShALI1wnR9Pk8U
         aP9FPevia30CAxIZnzH3KI8GVCSyKYr0c+igBzPgp2oxfSLlXfNIlxrV/5ri/dvgehd8
         aEng4JYyvBtQghUOYWXnnYJB9sTX09BSgctvE=
MIME-Version: 1.0
In-Reply-To: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
References: <ded07e5c09d72da478c6218658095f5a.squirrel@deadhat.com>
Date: Wed, 2 Mar 2011 00:30:45 +0100
Message-ID: <AANLkTimg1x56B4Yu=Zsd0VEci2i4jRKaMU+gxv3oFVr8@mail.gmail.com>
Subject: Re: Why is my copyright code in the linux kernel?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: dj@deadhat.com
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 1, 2011 at 11:49 PM,  <dj@deadhat.com> wrote:
> I was surprised to find code that is mine in Linux.
>
> Following the advice in the REPORTING_BUGS file, I'm sending this email
> here, for want of knowledge of a better contact.
>
> In 2002, I published code at www.deadhat.com to generate cryptographic
> vectors to aid in the development of IEEE 802.11i, a spec for which I was
> a contributor.
>
> One example can be found here:
> http://www.deadhat.com/wlancrypto/ccm1.2.c
>
> You will see a remarkable resemblance to parts of
> linux-2.6.36.2/drivers/staging/rt2860/common/cmm_aes.c. E.G. the AES code,

please note, this is a staging driver.
cc'ing gregkh.

> the MIC header code and some ancillary functions.
>
> However my header with my name and copyright has been removed. A different
> copyright has been added and it has been licensed under the GPL without my
> knowledge.
>
> I am a happy user of Linux, I don't want to cause trouble and I'd be quite
> honored to have some of my code in the kernel, so I'm not demanding the
> immediate removal of this code. I'm willing to GPL my code if necessary,
> but I do require proper attribution and acknowledgment of my copyright on
> my code
>
> I'd like to know who is an appropriate person to discuss this with.

the code is from ralink.

> Thank you,
> David Johnston
> dj@deadhat.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

-- 
Thanks,
//richard
