Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508Ab1FBINZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 04:13:25 -0400
Received: from linux-sh.org ([111.68.239.195]:46297 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758340Ab1FBINX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 04:13:23 -0400
Date: Thu, 2 Jun 2011 17:12:58 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Julia Lawall <julia@diku.dk>
Cc: Sascha Hauer <kernel@pengutronix.de>, kernel-janitors@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/10] drivers/video/imxfb.c: add missing clk_put
Message-ID: <20110602081258.GE6087@linux-sh.org>
References: <1306948213-20767-10-git-send-email-julia@diku.dk> <1306948213-20767-8-git-send-email-julia@diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306948213-20767-10-git-send-email-julia@diku.dk> <1306948213-20767-8-git-send-email-julia@diku.dk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 07:10:11PM +0200, Julia Lawall wrote:
>  drivers/video/imxfb.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

On Wed, Jun 01, 2011 at 07:10:13PM +0200, Julia Lawall wrote:
>  drivers/video/pxa168fb.c |   17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
> 
Both applied, thanks.
