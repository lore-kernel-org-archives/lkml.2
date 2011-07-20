Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751800Ab1GTUQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:16:18 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5664 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1GTUQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:16:16 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 20 Jul 2011 13:16:08 -0700
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
Date: Wed, 20 Jul 2011 13:16:08 -0700
Subject: RE: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v2] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxHF/dB+sbXVNoRSQiKUl6LNrkNkwAAVQTQ
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD2277@HQMAIL03.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com>
In-Reply-To: <CACxGe6uDVdemjbjY_i-_M_-VT8HuLdtXP-R9V8kB+pSSin4dEw@mail.gmail.com>
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

> Can the driver use sane defaults for any of these values?  This patch
> will be a lot smaller if there isn't the need to check all the return
> values each time.

The defaults are in the dt ehci node.  I'd really hate to duplicate these defaults in C code as well, if that's what you're suggesting (they're already duplicated privately elsewhere, sadly, in mach-tegra, but I'm hoping those defaults can go away once we move over to dt for good).  By failing probe if these defaults aren't present, I think it helps make sure the dt ehci node stays in sync with the code.

Or am I misunderstanding your comment?