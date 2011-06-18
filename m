Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab1FRSMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:12:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52622 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab1FRSM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:12:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] serial/imx: add device tree support
Date: Sat, 18 Jun 2011 20:11:32 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>, patches@linaro.org,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Jason Liu <jason.hui@linaro.org>, linux-kernel@vger.kernel.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>
References: <1308410354-21387-1-git-send-email-shawn.guo@linaro.org> <201106181821.46574.arnd@arndb.de> <20110618162655.GK8195@ponder.secretlab.ca>
In-Reply-To: <20110618162655.GK8195@ponder.secretlab.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106182011.33146.arnd@arndb.de>
X-Provags-ID: V02:K0:J89Eg4Ls03bb1aJUF9qOHPGVV7B3SdP6VLgKi2QKfy5
 8GfrFYf4KgZmR4A+p2Y58QtVxFZYoDrx2MvlUIAqHLEDREZkfa
 biNSbqtkjVBqNAFqGEhM47NTRhTRUMxlulDcWx0gQjBqjpH2KT
 KdK/qh/fkd0ShBIHhZH+ue+DgIaxw1rmRSsBXZGF1iGBc45xD5
 pOdhyjFv6Aw3brNw6oouA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 18 June 2011 18:26:55 Grant Likely wrote:
> On Sat, Jun 18, 2011 at 06:21:46PM +0200, Arnd Bergmann wrote:

> > Should this also support the "clock-frequency" property that 8250-style
> > serial ports support [1]?
> > 
> > For the flow-control properties, should we name that more generic? The
> > same property certainly makes sense for other serial-ports if it does
> > here. OTOH, I'm not sure it's actually reliable, because it also depends
> > on whether the other side of the connection and the cable support hw flow
> > control.
> 
> I'd like to see a few use cases before defining a common property.
> That said, has-rts-cts does sound like a useful generic property.
> Or maybe named "uart-has-rts-cts" to make it clear that it is a uart
> specific binding?
> 


Sounds ok to me.

	Arnd
