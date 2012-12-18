Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2LRSkI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:40:08 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47440 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2LRSkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:40:06 -0500
Date: Tue, 18 Dec 2012 21:39:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH RESEND 3/6] clk: exynos: Fix incorrect usage of
 IS_ERR_OR_NULL
Message-ID: <20121218183944.GH5032@mwanda>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
 <1355852048-23188-4-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355852048-23188-4-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 06:34:05AM +1300, Tony Prisk wrote:
> Resend to include mailing lists.
> 
> Replace IS_ERR_OR_NULL with IS_ERR on clk_get results.
> 

The original code is correct.  clk_get() can return NULL depending
on the .config.

regards,
dan carpenter

