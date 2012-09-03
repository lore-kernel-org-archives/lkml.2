Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab2ICQTO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:19:14 -0400
Received: from a83-160-107-163.adsl.xs4all.nl ([83.160.107.163]:36927 "EHLO
	d4rwin.no-ip.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756318Ab2ICQTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:19:13 -0400
Date: Mon, 3 Sep 2012 18:19:06 +0200
From: Matthias Kaehlcke <matthias.list@kaehlcke.net>
To: Samuel Ortiz <sameo@linux.intel.com>,
        "AnilKumar, Chimata" <anilkumar@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [RESEND] Documentation of device tree bindings for mfd devices
Message-ID: <20120903161906.GA23844@darwin>
Mail-Followup-To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"AnilKumar, Chimata" <anilkumar@ti.com>,
	Grant Likely <grant.likely@secretlab.ca>,
	Rob Herring <rob.herring@calxeda.com>,
	devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I wrote a driver for the backlight of the tps65217 PMIC, which is a
mfd device. The driver has device tree support and I want to document
the bindings.

It is not clear to me where this documentation should go. Currently
the bindings of the tps65217 driver are documented in
Documentation/devicetree/bindings/regulator/tps65217.txt , which
definitely isn't the right place to add backlight specific
documentation. The common practice seems to be to document mfd devices
including their subdevices in Documentation/devicetree/bindings/mfd.
To follow this convention my steps would be moving tps65217.txt to the
mfd directory and adding the backlight specific documentation.

Please confirm whether this is the correct/preferred way to document
device tree bindings of mfd devices

-- 
Matthias Kaehlcke
Embedded Linux Developer
Amsterdam

            You can chain me, you can torture me, you can even
          destroy this body, but you will never imprison my mind
                            (Mahatma Gandhi)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
