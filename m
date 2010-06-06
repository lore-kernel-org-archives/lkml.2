Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755126Ab0FFKPR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:15:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:44115 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0FFKPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:15:16 -0400
Subject: Re: [PATCH] mtd: nand: mpc5121_nfc.c: Fix build failures
From: David Woodhouse <dwmw2@infradead.org>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <1275323836-15711-1-git-send-email-agust@denx.de>
References: <1275323836-15711-1-git-send-email-agust@denx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 06 Jun 2010 11:15:08 +0100
Message-ID: <1275819308.17903.3099.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-6.fc13) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-31 at 18:37 +0200, Anatolij Gustschin wrote:
> Fixes build errors caused by the:
>  - OF device_node pointer being moved into struct device
>  - removal of the match_table field from struct of_platform_driver
> 
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>

Um, this isn't applicable to 2.6.35, is it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

