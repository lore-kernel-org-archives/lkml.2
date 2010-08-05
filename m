Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab0HEWax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 18:30:53 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55154 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934578Ab0HEWZD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 18:25:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TDsWFZO6OVHO18XzeFu2swim0dK9TI+43s5d2TpsSFACgmU/rKa2EiUBKUb9zhyYKo
         Src037pXeXi9mdD5pQq7f2Rp1p4pMtn7mUD5T0/jmtGr0wi5xInB1Gr5eh4DzGcH2hEF
         h/aKb/g0BrDr/dDnXRdq440npWdDvLNiUKRlQ=
MIME-Version: 1.0
In-Reply-To: <adabp9g3ehu.fsf@roland-alpha.cisco.com>
References: <AANLkTin5gz-NBGYrmdOQ4F4s-fbETq642JVsHEEJY4HD@mail.gmail.com>
	<adabp9g3ehu.fsf@roland-alpha.cisco.com>
Date: Fri, 6 Aug 2010 00:25:02 +0200
X-Google-Sender-Auth: Wn0HI2_-bzpRPrkVwA2s99ncCmE
Message-ID: <AANLkTinHYXv_S+p-0iO1_caoXxp5-KmgwP5q81KGWWoV@mail.gmail.com>
Subject: Re: Best way to send several patches
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/6 Roland Dreier <rdreier@cisco.com>:
>  > The question is, should I just send them all to this mailinglist
>  > (Section 3 of Documentation/SubmittingPatches - the one with the patch
>  > bomb - suggest that this is a bad idea), or how should I do it? (I
>  > have only submitted a single patch before, so I didn't have to worry
>  > about that back then).
>
> I would suggest sending a small batch of patches (say, four or five at
> most) and see how that goes.  That way, in case you make some mistake in
> formatting or something, you don't have to send another huge pile when
> you resend.
>
> Once your initial batch is accepted and you have the hang of submitting
> patches, then you can submit bigger batches.  But I would recommend
> having each batch have a common theme.  For example there was the recent
> series of 42 fixes for confusing if indentation -- a big batch of fixes
> for the same problem in different places, which is exactly the right way
> to do things.

Thanks, I'll do that.
But I'll wait until rc1 is out as suggested :-)

>  - Roland
> --
> Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
