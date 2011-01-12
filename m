Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab1ALGCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 01:02:32 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:52274 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab1ALGCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 01:02:30 -0500
Date: Wed, 12 Jan 2011 15:00:23 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, Vincent Sanders <support@simtec.co.uk>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 05/16] s3c2410fb: don't treat NULL clk as an error
Message-ID: <20110112060022.GB2350@linux-sh.org>
References: <1294749833-32019-1-git-send-email-jamie@jamieiles.com> <1294749833-32019-6-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294749833-32019-6-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 12:43:42PM +0000, Jamie Iles wrote:
> clk_get() returns a struct clk cookie to the driver and some platforms
> may return NULL if they only support a single clock.  clk_get() has only
> failed if it returns a ERR_PTR() encoded pointer.
> 
> Cc: Vincent Sanders <support@simtec.co.uk>
> Cc: linux-fbdev@vger.kernel.org
> Signed-off-by: Jamie Iles <jamie@jamieiles.com>

Applied, thanks.
