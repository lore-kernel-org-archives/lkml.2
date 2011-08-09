Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1HIQV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 12:21:57 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4028 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1HIQVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 12:21:55 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 09 Aug 2011 09:21:32 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Ben Dooks <ben-i2c@fluff.org>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Axel Lin <axel.lin@gmail.com>, Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>
Date: Tue, 9 Aug 2011 09:21:31 -0700
Subject: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
 empty of_get_property for non-dt)
Thread-Topic: Tegra I2C driver compilation failure (was: RE: [PATCH] dt: add
 empty of_get_property for non-dt)
Thread-Index: AcxWsFc11cpLxv4jSKS6ILv8C370YA==
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04A0687289@HQMAIL01.nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren wrote at Monday, August 08, 2011 1:26 PM:
> Rob Herring wrote at Sunday, August 07, 2011 8:38 AM:
> > On 08/05/2011 05:50 PM, Stephen Warren wrote:
> > > The patch adds empty function of_get_property for non-dt build, so that
> > > drivers migrating to dt can save some '#ifdef CONFIG_OF'.
> > >
> > > This also fixes the current Tegra compile problem in linux-next.
> >
> > You could just use of_property_read_u32 in the driver. It already has
> > empty version and will simplify the driver code some.
> 
> Yes, that would also work.
> 
> Grant, Ben, do you have a preference for which option to choose?

Well, all three possible fixes have been posted now:

Add ifdef to i2c driver:
http://www.spinics.net/lists/linux-tegra/msg01720.html

Implement empty of_get_property:
http://www.spinics.net/lists/linux-tegra/msg01881.html

Switch i2c driver to use of_property_read_u32:
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/127807

Ben, please could you please pick one of the changes and apply it, so
that linux-next compiles for Tegra? Thanks!

-- 
nvpublic

