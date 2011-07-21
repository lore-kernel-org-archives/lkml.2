Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071Ab1GUVn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:43:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17866 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753957Ab1GUVnY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:43:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 21 Jul 2011 14:43:16 -0700
From: Andrew Chew <AChew@nvidia.com>
To: Dan Willemsen <dwillemsen@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jul 2011 14:43:15 -0700
Subject: RE: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxH7PbWBIRauuLQT0Cwibms8InM5wAAghFQ
Message-ID: <643E69AA4436674C8F39DCC2C05F76383CF0DD2281@HQMAIL03.nvidia.com>
References: <1311283067-18952-1-git-send-email-achew@nvidia.com>
 <CA4DE74D.50C07%dwillemsen@nvidia.com>
In-Reply-To: <CA4DE74D.50C07%dwillemsen@nvidia.com>
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

> On 7/21/11 2:17 PM, "Andrew Chew" <achew@nvidia.com> wrote:
> >From: Andrew Chew <achew@nvidia.com>
> >
> >Add code to try to get platform data information (register base, irq,
> >modes, various tuning parameters) from device tree, if not present in
> >board
> >files.
> 
> This patch no longer gets the register base or irq, just the modes and
> tuning parameters.
> 
> - Dan Willemsen

You're totally right, Dan.  Grant, would you mind fixing the commit message, if nothing else comes up?  Or would you prefer I send a new patchset out?

I suppose the commit message should just read:

Add code to try to get platform data information (modes, various tuning
parameters) from device tree, if not present in board files.