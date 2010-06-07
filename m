Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0FGHJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:09:59 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:40798 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674Ab0FGHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:09:58 -0400
X-Auth-Info: e0dmvXsajaxbn6eEqVZE4AKmWLf70cMqlKuXaSiBZ1Y=
Date: Mon, 7 Jun 2010 09:09:19 +0200
From: Anatolij Gustschin <agust@denx.de>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] mtd: nand: mpc5121_nfc.c: Fix build failures
Message-ID: <20100607090919.20129f51@wker>
In-Reply-To: <1275819308.17903.3099.camel@macbook.infradead.org>
References: <1275323836-15711-1-git-send-email-agust@denx.de>
	<1275819308.17903.3099.camel@macbook.infradead.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Jun 2010 11:15:08 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Mon, 2010-05-31 at 18:37 +0200, Anatolij Gustschin wrote:
> > Fixes build errors caused by the:
> >  - OF device_node pointer being moved into struct device
> >  - removal of the match_table field from struct of_platform_driver
> > 
> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> 
> Um, this isn't applicable to 2.6.35, is it?

Do you mean it isn't applicable to 2.6.34? This patch is needed and
applicable to 2.6.35-rc1. It has already been collected by Grant
and the breakage is fixed in 2.6.35-rc2.
