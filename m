Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626Ab1CVSWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:22:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab1CVSWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:22:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w6GtnykE5ZhdtpV7nM8zTRKMtebssn3M6tVRMlCkTcuXrZpKt9g79T0vs3TAhPmDH1
         j0jsWi4NEywBiAamF3XR/DVUFjykVN7LR7jrc1WHowwgzqI51XI1wkffjh1e44+ZxAiZ
         +G3mkexnT0oPNZvU52NHZnSOAqR47FyZNQ4FY=
MIME-Version: 1.0
In-Reply-To: <1300786517-3695-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1300786517-3695-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 22 Mar 2011 11:22:17 -0700
X-Google-Sender-Auth: lXSGWXSHFibQNj4iqaNxlCalviE
Message-ID: <AANLkTin=VL=nvOHUrfZm8HeQ=v_C_azqN2tVEVVwGy4Y@mail.gmail.com>
Subject: Re: [PATCH] dma: let IMX_DMA depend on IMX_HAVE_DMA_V1 instead of an
 explicit list of SoCs
From: Dan Williams <dan.j.williams@intel.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/22 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> As a side effect this makes IMX_DMA selectable on i.MX21 again, because
> the symbol ARCH_MX21 doesn't exist (MACH_MX21 would have been more correct).
>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Applied, thanks.

--
Dan
