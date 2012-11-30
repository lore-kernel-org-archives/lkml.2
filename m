Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030848Ab2K3Pi7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 10:38:59 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:46993 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030753Ab2K3Pi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 10:38:57 -0500
Date: Fri, 30 Nov 2012 15:38:56 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Philip, Avinash" <avinashphilip@ti.com>
cc: Thierry Reding <thierry.reding@avionic-design.de>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Hiremath, Vaibhav" <hvaibhav@ti.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
Subject: RE: [PATCH v5 00/12] Support for AM33xx PWM Subsystem
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA0E480@DBDE01.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1211301533560.18138@utopia.booyaka.com>
References: <1354006097-25895-1-git-send-email-avinashphilip@ti.com> <20121128142101.GB21042@avionic-0098.adnet.avionic-design.de> <518397C60809E147AF5323E0420B992E3EA0E480@DBDE01.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2012, Philip, Avinash wrote:

> Is there any way to get HWMOD and DT patches getting accepted in 3.8?
> Or should I wait and send rebased patch based on 3.8-rc1?

Our upstreams aren't taking any more new features for v3.8, so basing on 
v3.8-rc1 is the best thing to do now.

In the meantime, you can try basing your series against a recent for-next 
HEAD to get an early start on testing, etc.


- Paul
