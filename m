Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab1GTWxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:53:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:4662 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab1GTWxE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:53:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 20 Jul 2011 15:52:56 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
CC: "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 20 Jul 2011 15:52:55 -0700
Subject: RE: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxHF/dB+sbXVNoRSQiKUl6LNrkNkwAF5Waw
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD227C@HQMAIL03.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com>
In-Reply-To: <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       retval = of_property_read_u32(dn, "hssync_start_delay",
> > +                                     (u32 
> *)&phy_config->hssync_start_delay);
> 
> Gah!  Don't cast pointers that way.  It will break badly if the sizes
> don't match.  The variable *must* be a u32.

Can we have u16 and u8 versions of of_property_read, then?  It'll simplify code.  I'll be happy to submit a patch for that if that's what we want.