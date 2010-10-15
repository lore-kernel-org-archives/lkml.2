Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151Ab0JOICx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 04:02:53 -0400
Received: from elettra.colt-to.towertech.it ([213.215.222.70]:43404 "EHLO
	smtp.towertech.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab0JOICu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 04:02:50 -0400
Date: Fri, 15 Oct 2010 10:03:59 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: achew@nvidia.com
Cc: jmayo@nvidia.com, olof@lixom.net, greg@kroah.com, mcuos.com@gmail.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        rtc-linux@googlegroups.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/1 V2] rtc: Add real-time clock driver for Tegra.
Message-ID: <20101015100359.7860028e@linux.lan.towertech.it>
In-Reply-To: <1287089791-25673-1-git-send-email-achew@nvidia.com>
References: <1287089791-25673-1-git-send-email-achew@nvidia.com>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010 13:56:31 -0700
achew@nvidia.com wrote:

> +	info->rtc_base = ioremap(res->start, res->end - res->start + 1);

 please use resource_size()


> +MODULE_DESCRIPTION("driver for Tegra internal RTC");
> +MODULE_LICENSE("GPL");

 missing MODULE_AUTHOR with email address

 pending those corrections,


 Acked-by: Alessandro Zummo <a.zummo@towertech.it>


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

