Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659Ab1DQRyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 13:54:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64427 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1DQRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 13:54:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH v2] uio/pdrv_genirq: Add OF support
Date: Sun, 17 Apr 2011 19:53:42 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Michal Simek <monstr@monstr.eu>, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de
References: <1302774106-32764-1-git-send-email-monstr@monstr.eu> <20110414230602.GC2780@local>
In-Reply-To: <20110414230602.GC2780@local>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104171953.42440.arnd@arndb.de>
X-Provags-ID: V02:K0:72h5kjfpGQon3P0Gihyb+UkKngCxx1TA+K6WtMH+VZd
 2j51KLSACMYR6ny8SIuph4F1J5rfDwCOp5mWEX9UZkOi16NDJS
 B3oRUT/zcx8TVNPbhYFczDmJnjvuOYYL9xZdZK1a/7iCsPgDXB
 drGHIt6vaYUAWap8Iw5R83qVr7DmA4tYCqS7KR2tWWA/yy2cQr
 jR6mK8C5Ih8sReMm4VFYg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 April 2011, Hans J. Koch wrote:
> > +#ifdef CONFIG_OF
> > +/*
> > + * Empty match table for of_platform binding
> > + * Select your custom compatible string in format
> > + * { .compatible = "<compatible string>", },
> > + */
> > +static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
> > +     { /* end of list */ },
> 
> doesn't that want a NULL termination?
> 

It is NULL terminated, that is the /* end of list */.

	Arnd
