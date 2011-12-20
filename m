Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1LTU5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 15:57:23 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:53848 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751514Ab1LTU5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 15:57:14 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/aRPR4amUF95Kd8ICqG4x4
Date: Tue, 20 Dec 2011 12:57:06 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: alsa-devel@alsa-project.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, linux-omap@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>, Jarkko Nikula <jarkko.nikula@bitmer.com>
Subject: Re: [PATCH v2 1/7][RESEND] ARM: OMAP1: ams-delta: register latch
 dependent devices later
Message-ID: <20111220205706.GH17267@atomide.com>
References: <1323634328-856-1-git-send-email-jkrzyszt@tis.icnet.pl>
 <201112200028.32947.jkrzyszt@tis.icnet.pl>
 <20111220180610.GB24444@atomide.com>
 <201112202134.36802.jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112202134.36802.jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111220 12:03]:
> On Tuesday 20 of December 2011 at 19:06:11, Tony Lindgren wrote:
> 
> > To deal with the init order issues, you can pass a set_power
> > function pointer in platform_data that the driver can use. Or
> > set up a fixed regulator for it.
> 
> I'm already working on the follow up patch series mentioned in the cover 
> letter, and yes, I'm using the fixed regulator. Be patient, please, as 
> my resources are somehow limited.

Yes, I understand. For this patch I'm fine with the late_initcall
changes Russell suggested, then the rest can be done in separate
patches later on.

Regards,

Tony
