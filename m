Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757230Ab0LNIop (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:44:45 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33492 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116Ab0LNIoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:44:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=WE5haA4d+q647s9dnbsRmUQVfbN6Cp6oHHjHzPiAq23Om1xU65/aYz30jYIY1ilX01
         kcCV9yWFqbiootqRwatnjL7rFA0uEZqmDPiNGE6RJbsmtRtsUazHZhZlnoLtAVgsIoTI
         5DNQ97sf/+D+pMfpxc4KdZC2GpG5eQePn8pEI=
MIME-Version: 1.0
In-Reply-To: <1292244521-20756-1-git-send-email-nicolas.ferre@atmel.com>
References: <1292244521-20756-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 14 Dec 2010 00:44:42 -0800
X-Google-Sender-Auth: mLS3q0SRhCc4XwZhjT1jnap9zSE
Message-ID: <AANLkTi=bpeyJL=ah1Fy9591EM8C+eF8-h6Tpbmq37JaC@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: at_hdmac: fix buffer transfer size specification
From: Dan Williams <dan.j.williams@intel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        avictor.za@gmail.com, plagnioj@jcrosoft.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 4:48 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Buffer transfer size is the number of transfers to be performed in
> relation with the width of the _source_ interface.
> So in the DMA_FROM_DEVICE case, it should be the register width that
> should be taken into account.
>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

Applied.
