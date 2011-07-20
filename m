Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752320Ab1GTUEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 16:04:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:32996 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab1GTUEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 16:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF50@HQMAIL01.nvidia.com>
References: <1311190690-18334-1-git-send-email-achew@nvidia.com>
 <1311190690-18334-2-git-send-email-achew@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF049EBDEF50@HQMAIL01.nvidia.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 20 Jul 2011 14:03:42 -0600
X-Google-Sender-Auth: RpI8T8EmkJIQ08FUPwvVyUnzKx8
Message-ID: <CACxGe6tGt43MvM8hqYQX=N9BtjffqZLfMOYZNKGOhgZbv1g6gw@mail.gmail.com>
Subject: Re: [PATCH 2/3 v2] dt: tegra20: Add ehci host controller nodes.
To: Stephen Warren <swarren@nvidia.com>
Cc: Andrew Chew <AChew@nvidia.com>, "olof@lixom.net" <olof@lixom.net>,
        Dan Willemsen <dwillemsen@nvidia.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Venkat Moganty <vmoganty@nvidia.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 1:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
> achew@nvidia.com wrote at Wednesday, July 20, 2011 1:38 PM:
>> These values were derived from various headers in arch/arm/mach-tegra.
>>
>> Signed-off-by: Andrew Chew <achew@nvidia.com>
>
> Patches 2 and 3:
>
> Acked-by: Stephen Warren <swarren@nvidia.com>
>
> I know Olof had suggested splitting the phy properties into a sub-node
> of the EHCI controller. I'll let you and him discuss that; I don't
> really have an opinion on that.

My comments on the property names will need to be resolved.

g.
