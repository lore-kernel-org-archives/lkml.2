Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030272Ab2CFCf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 21:35:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42955 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030194Ab2CFCf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 21:35:57 -0500
Date: Tue, 6 Mar 2012 10:50:27 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 2/2] Regulator: Add Anatop regulator driver
Message-ID: <20120306025025.GL16232@S2101-09.ap.freescale.net>
References: <1330960049-28170-1-git-send-email-paul.liu@linaro.org>
 <1330960049-28170-2-git-send-email-paul.liu@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330960049-28170-2-git-send-email-paul.liu@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 11:07:28PM +0800, Ying-Chun Liu (PaulLiu) wrote:
...
> +MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>");
> +MODULE_AUTHOR("Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");

I meant something like:

MODULE_AUTHOR("Nancy Chen <Nancy.Chen@freescale.com>, "
	      "Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>");

Otherwise:

Acked-by: Shawn Guo <shawn.guo@linaro.org>

> +MODULE_DESCRIPTION("ANATOP Regulator driver");
> +MODULE_LICENSE("GPL v2");

-- 
Regards,
Shawn
