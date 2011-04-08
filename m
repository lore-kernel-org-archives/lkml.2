Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766Ab1DHT2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 15:28:06 -0400
Received: from mail.perches.com ([173.55.12.10]:4579 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757680Ab1DHT2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 15:28:04 -0400
Subject: Re: [RFC][WAS:bcmai][PATCH V2] axi: add AXI bus driver
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        George Kashperko <george@znau.edu.ua>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
References: <1302291900-1902-1-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Apr 2011 12:28:01 -0700
Message-ID: <1302290881.1664.7.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-08 at 21:45 +0200, Rafał Miłecki wrote:
> diff --git a/include/linux/axi/axi.h b/include/linux/axi/axi.h
[]
> +#define axi_info	pr_info
> +#ifdef CONFIG_AXI_DEBUG
> +#define axi_debug	pr_debug
> +#else
> +#define axi_debug	do { } while (0)
> +#endif
> +#define axi_err		pr_err

I think redefining standard functionality like
this doesn't gain anything and loses some basic
grep capability.


