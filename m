Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab2LRTD7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:03:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34551 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab2LRTD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:03:57 -0500
Date: Tue, 18 Dec 2012 22:03:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Inki Dae <inki.dae@samsung.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        dri-devel@lists.freedesktop.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH RESEND 3/6] clk: exynos: Fix incorrect usage of
 IS_ERR_OR_NULL
Message-ID: <20121218190334.GK5032@mwanda>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>
 <1355852048-23188-4-git-send-email-linux@prisktech.co.nz>
 <20121218183944.GH5032@mwanda>
 <1355856767.23479.3.camel@gitbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355856767.23479.3.camel@gitbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't care either way, but being different from the documentation
is less bad than crashing which is what your patch does.  Please
be more careful in the future.

regards,
dan carpenter

