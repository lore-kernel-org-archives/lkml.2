Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958Ab1GUV10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 17:27:26 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16129 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1GUV1X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 17:27:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 21 Jul 2011 14:27:17 -0700
From: Dan Willemsen <dwillemsen@nvidia.com>
To: Andrew Chew <AChew@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "olof@lixom.net" <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>
CC: "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 21 Jul 2011 14:27:13 -0700
Subject: Re: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Topic: [PATCH 1/3 v4] usb: tegra20-ehci: Add devicetree support.
Thread-Index: AcxH7PbWBIRauuLQT0Cwibms8InM5w==
Message-ID: <CA4DE74D.50C07%dwillemsen@nvidia.com>
In-Reply-To: <1311283067-18952-1-git-send-email-achew@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.12.0.110505
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/21/11 2:17 PM, "Andrew Chew" <achew@nvidia.com> wrote:
>From: Andrew Chew <achew@nvidia.com>
>
>Add code to try to get platform data information (register base, irq,
>modes, various tuning parameters) from device tree, if not present in
>board
>files.

This patch no longer gets the register base or irq, just the modes and
tuning parameters.

- Dan Willemsen

>Signed-off-by: Andrew Chew <achew@nvidia.com>
>Acked-by: Stephen Warren <swarren@nvidia.com>
>---
>Applied Olof Johansson's comments:
>- Use direct assignment when copying default config structs.
>- Use __devinitdata for static default config structs.
>- Don't compile the default config structs if CONFIG_OF is disabled, to
>avoid
>  a warning.
>
> .../devicetree/bindings/usb/tegra20-ehci.txt       |   27 +++
> drivers/usb/host/ehci-tegra.c                      |  189
>++++++++++++++++++++
> 2 files changed, 216 insertions(+), 0 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/usb/tegra20-ehci.txt

--
nvpublic

