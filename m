Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab1LGXne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 18:43:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35650 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1LGXnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 18:43:32 -0500
MIME-Version: 1.0
In-Reply-To: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
References: <1317189007-23033-1-git-send-email-alim.akhtar@samsung.com>
Date: Thu, 8 Dec 2011 00:43:32 +0100
Message-ID: <CACRpkdZC8LOOLkWbrPbXN_nKaw-WvueusYDyrX48Q1Pcdwv3Aw@mail.gmail.com>
Subject: Re: [PATCH V2 0/1] dmaengine/amba-pl08x: Add support for s3c64xx DMAC
From: Linus Walleij <linus.walleij@linaro.org>
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, viresh.kumar@st.com,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 7:50 AM, Alim Akhtar <alim.akhtar@samsung.com> wrote:

> This patch modifies the amba-pl08x driver for s3c64xx.
> The DMA controller of S3C64XX is a variant of PrimeCell pl080 DMAC.
> S3C64xx contents extra register to hold the TransferSize.

Alim what is happening with this patch series?

I was really happy with the rate of progress we had and Viresh & I
have given most feedback needed to complete this I think.

Yours,
Linus Walleij
