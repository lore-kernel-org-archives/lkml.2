Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab2HYHN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 03:13:56 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44373 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2HYHNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 03:13:47 -0400
Date: Sat, 25 Aug 2012 16:13:44 +0900
From: Simon Horman <horms@verge.net.au>
To: Hideki EIRAKU <hdk@igel.co.jp>
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH 0/2] Renesas IPMMU driver for sh7372
Message-ID: <20120825071344.GI29755@verge.net.au>
References: <1343197742-13630-1-git-send-email-hdk@igel.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343197742-13630-1-git-send-email-hdk@igel.co.jp>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 03:29:00PM +0900, Hideki EIRAKU wrote:
> This is the Renesas IPMMU driver, IOMMU API implementation and IPMMU
> device support for sh7372 (AP4EVB and Mackerel).
> 
> The IPMMU module supports the MMU function and the PMB function.  The
> MMU function provides address translation by pagetable compatible with
> ARMv6.  The PMB function provides address translation including
> tile-linear translation.  This is implementation of the MMU function.

Hi,

I am wondering if anyone has had a chance to review this short series.
It seems reasonable to me with the minor exception that I would
be happier the second patch to update the relevant defconfigs
to either enable or disable the driver.

I am also curious to know how this driver may be tested.
