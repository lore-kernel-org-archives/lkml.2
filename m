Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2DOOni (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:43:38 -0400
Received: from zabrina.hetzner-de.towertech.it ([178.63.16.19]:58826 "EHLO
	zabrina.hetzner-de.towertech.it" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754126Ab2DOOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:43:37 -0400
X-Greylist: delayed 507 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Apr 2012 10:43:36 EDT
Date: Sun, 15 Apr 2012 16:34:56 +0200
From: Alessandro Zummo <a.zummo@towertech.it>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: rtc-linux@googlegroups.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, Anish Trivedi <anish@freescale.com>,
        Eric Miao <eric.miao@linaro.org>, Anson Huang <b20788@freescale.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH v2] rtc: add support for Freescale SNVS RTC
Message-ID: <20120415163456.67cbac58@linux.lan.towertech.it>
In-Reply-To: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
References: <1334387237-23519-1-git-send-email-paul.liu@linaro.org>
Organization: Tower Technologies
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Apr 2012 15:07:17 +0800
"Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org> wrote:

> atic int snvs_rtc_proc(struct device *dev, struct seq_file *seq)
> +{
> +	struct rtc_drv_data *pdata = dev_get_drvdata(dev);
> +	void __iomem *ioaddr = pdata->ioaddr;
> +
> +	seq_printf(seq, "alarm_IRQ\t: %s\n",
> +		   (((readl(ioaddr + SNVS_LPCR)) & SNVS_LPCR_LPTA_EN) !=
> +		    0) ? "yes" : "no");
> +
> +	return 0;
> +}
> +

 Please consider removing this unless truly necessary.

-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

