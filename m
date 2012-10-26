Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab2JZHrU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 03:47:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:57286 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab2JZHrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 03:47:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: balbi@ti.com
Subject: Re: [PATCH v2 3/3] ARM: OMAP: ocp2scp: create omap device for ocp2scp
Date: Fri, 26 Oct 2012 07:47:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Kishon Vijay Abraham I <kishon@ti.com>, tony@atomide.com,
        linux@arm.linux.org.uk, b-cousson@ti.com, olof@lixom.net,
        rdunlap@xenotime.net, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1349675983-23803-1-git-send-email-kishon@ti.com> <1349675983-23803-4-git-send-email-kishon@ti.com> <20121026065012.GC22206@arwen.pp.htv.fi>
In-Reply-To: <20121026065012.GC22206@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210260747.11848.arnd@arndb.de>
X-Provags-ID: V02:K0:qze4PBmsaah34KHIgTAp3/1rWrfmq5icpjA02UCI5oA
 v20STP7PwMkdNr86cWU2IsKLhjACcOKWGS0gHt8ACIFAbsz9lV
 ++0+VN2JpRtIqzT8mRcmsfLU9LxtFoLyKbWlVBKEVSwquiqHnj
 K6BMhJ430ejLZUdPFARUf6VITv9GKfOX6pb3HYgxvKdc+RbjRx
 oX752v2QFqbrNkHSEYWeXwQZ6SXSLQGpE97x0s/7rUsGFCV/Ws
 oNL/Twc+bATebDzfw/pDYurVf7BLfiA7ZAE0zh4u5BMOo24wwS
 RWj3N3dzu1OynHx7GlZB4gFmFzuVxxqU+YTNvvGuknXJpeSI6L
 FSe3rQr/8W9r2xMnRQhE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012, Felipe Balbi wrote:
> > +static void omap_init_ocp2scp(void)
> > +{
> > +     struct omap_hwmod       *oh;
> > +     struct platform_device  *pdev;
> > +     int                     bus_id = -1, dev_cnt = 0, i;
> > +     struct omap_ocp2scp_dev *ocp2scp_dev;
> > +     const char              *oh_name, *name;
> > +     struct omap_ocp2scp_platform_data *pdata;
> > +
> > +     oh_name = "ocp2scp_usb_phy";
> > +     name    = "omap-ocp2scp";
> 
> how about adding checks here to return early case we're not running on
> OMAP4 or OMAP5 ??
> 

I suppose even OMAP4-only, since OMAP5 always has DT enabled.

	Arnd
