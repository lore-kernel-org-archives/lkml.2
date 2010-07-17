Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760052Ab0GQQCw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jul 2010 12:02:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41491 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304Ab0GQQCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jul 2010 12:02:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=GMMmy7cyGfbcSDWcL4SuEoSQ4R7HSzMSKeW14n6GSR+kKn8I1OgW2m9yV/vaLZLsSk
         9MAEJ/VIS2EmL0/HWHa48iIMIRC2SrTmwT2vjWg0LhZ0rEdO2yGraXpFTKkJb/4Gu9Yq
         syfu0c+7Qnvh4dTtbFCRY0M4z02g+hCi0AYgM=
MIME-Version: 1.0
In-Reply-To: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
References: <1279371808-24804-1-git-send-email-brgerst@gmail.com>
Date: Sat, 17 Jul 2010 19:02:50 +0300
X-Google-Sender-Auth: nc7d7QsyVeE1Tr1O97-xSXHDpLg
Message-ID: <AANLkTimfJNt1_KuJyDExWHUhLsaSTwKOS-a4o9Yvo4Ig@mail.gmail.com>
Subject: Re: [PATCH 1/3] x86: Remove redundant K6 MSRs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Brian Gerst <brgerst@gmail.com>
Cc: hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 17, 2010 at 4:03 PM, Brian Gerst <brgerst@gmail.com> wrote:
> MSR_K6_EFER is unused, and MSR_K6_STAR is redundant with MSR_STAR.
>
> Signed-off-by: Brian Gerst <brgerst@gmail.com>

Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
