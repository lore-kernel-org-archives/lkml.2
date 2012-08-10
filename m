Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab2HJG2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:28:12 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:51259 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2HJG2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:28:09 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/xmePJko9d43x55ETcwkG3
Date: Thu, 9 Aug 2012 23:28:00 -0700
From: Tony Lindgren <tony@atomide.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        alsa-devel@alsa-project.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [PATCH 07/11] ARM: OMAP/ASoC: Zoom2: Let the codec to handle
 the hs_extmute GPIO
Message-ID: <20120810062800.GO11011@atomide.com>
References: <1344418887-5262-1-git-send-email-peter.ujfalusi@ti.com>
 <1344418887-5262-8-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344418887-5262-8-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi <peter.ujfalusi@ti.com> [120808 02:42]:
> Remove the use of set_hs_extmute callback and let the codec driver to
> handle the extmute GPIO.

Acked-by: Tony Lindgren <tony@atomide.com>
