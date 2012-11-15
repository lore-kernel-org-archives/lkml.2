Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768173Ab2KOP6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 10:58:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52277 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993423Ab2KOP6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 10:58:19 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] bindings: i2c: use consistent naming for i2c binding descriptions
To: Wolfram Sang <wolfram@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-arm-kernel@lists.infradead.org, devicetree-discuss@ozlabs.org,
        Wolfram Sang <wolfram@the-dreams.de>,
        Rob Herring <robherring2@gmail.com>
In-Reply-To: <1352827003-24287-1-git-send-email-wolfram@the-dreams.de>
References: <1352827003-24287-1-git-send-email-wolfram@the-dreams.de>
Date: Thu, 15 Nov 2012 15:58:14 +0000
Message-Id: <20121115155814.30AA83E194B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 18:16:43 +0100, Wolfram Sang <wolfram@the-dreams.de> wrote:
> Filenames of devictree binding documentation seems to be arbitrary and
> for me it is unneeded hazzle to find the corresponding documentation for
> a specific driver.
> 
> Naming the description the same as the driver is a lot easier and makes
> sense to me since the driver defines the binding it understands.
> 
> Also, remove a reference in one source to the binding documentation, since path
> information easily gets stale.
> 
> Signed-off-by: Wolfram Sang <wolfram@the-dreams.de>
> Cc: Rob Herring <robherring2@gmail.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Applied, thanks.

g.

