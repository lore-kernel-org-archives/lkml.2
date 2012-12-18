Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2LRSse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:48:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20097 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab2LRSsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:48:31 -0500
Date: Tue, 18 Dec 2012 21:48:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH RESEND 2/6] clk: exynos: Fix incorrect usage of
 IS_ERR_OR_NULL
Message-ID: <20121218184816.GJ5032@mwanda>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
 <1355852048-23188-3-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355852048-23188-3-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 06:34:04AM +1300, Tony Prisk wrote:
> Resend to include mailing lists.

These kind of comments should go under the Signed of by line under
a "---" line.  They will be removed by git-am instead of being
preserved in the git log.

Signed-off-by bla bla blah
---
Commments...

<patch>

regards,
dan carpenter

