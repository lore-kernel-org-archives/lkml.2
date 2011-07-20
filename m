Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1GTTxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:53:07 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1637 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GTTxF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:53:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 20 Jul 2011 12:52:59 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Chew <AChew@nvidia.com>
Date: Wed, 20 Jul 2011 12:52:58 -0700
Subject: RE: [PATCH 2/3 v2] dt: tegra20: Add ehci host controller nodes.
Thread-Topic: [PATCH 2/3 v2] dt: tegra20: Add ehci host controller nodes.
Thread-Index: AcxHFQkTrlnS7JYKR3qmibRzuwTR8QAAWrDQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF50@HQMAIL01.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <1311190690-18334-2-git-send-email-achew@nvidia.com>
In-Reply-To: <1311190690-18334-2-git-send-email-achew@nvidia.com>
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

achew@nvidia.com wrote at Wednesday, July 20, 2011 1:38 PM:
> These values were derived from various headers in arch/arm/mach-tegra.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>

Patches 2 and 3:

Acked-by: Stephen Warren <swarren@nvidia.com>

I know Olof had suggested splitting the phy properties into a sub-node
of the EHCI controller. I'll let you and him discuss that; I don't
really have an opinion on that.

-- 
nvpublic

