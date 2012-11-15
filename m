Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768410Ab2KOQaq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:30:46 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:44512 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768378Ab2KOQao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:30:44 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] arm-dt: Enable DT proc updates.
To: Rob Herring <robherring2@gmail.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Russell King <linux@arm.linux.org.uk>, Matt Porter <mporter@ti.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <5091D8A8.9010307@gmail.com>
References: <1351699069-4661-1-git-send-email-panto@antoniou-consulting.com> <5091D8A8.9010307@gmail.com>
Date: Thu, 15 Nov 2012 16:30:39 +0000
Message-Id: <20121115163039.E8BBD3E194B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012 21:04:24 -0500, Rob Herring <robherring2@gmail.com> wrote:
> On 10/31/2012 10:57 AM, Pantelis Antoniou wrote:
> > This simple patch enables dynamic changes of the DT tree on runtime
> > to be visible to the device-tree proc interface.
> > 
> > Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> 
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Applied, thanks.

g.

