Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068Ab1KBPYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:24:54 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:42360 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932543Ab1KBPYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:24:51 -0400
MIME-Version: 1.0
In-Reply-To: <20111102152116.GB14916@n2100.arm.linux.org.uk>
References: <1320185752-568-1-git-send-email-omar.ramirez@ti.com>
	<1320185752-568-5-git-send-email-omar.ramirez@ti.com>
	<20111102152116.GB14916@n2100.arm.linux.org.uk>
Date: Wed, 2 Nov 2011 10:24:49 -0500
Message-ID: <CAB-zwWhX5ayyG-Tz7rT4=gG-WZTpHEQskq50MMgPv8bj0VMiGw@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] OMAP3/4: iommu: adapt to runtime pm
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <b-cousson@ti.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, lo <linux-omap@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>, lm <linux-media@vger.kernel.org>,
        "Roedel, Joerg" <Joerg.Roedel@amd.com>,
        iommu@lists.linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 10:21 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Tue, Nov 01, 2011 at 05:15:52PM -0500, Omar Ramirez Luna wrote:
>> Use runtime PM functionality interfaced with hwmod enable/idle
>> functions, to replace direct clock operations, reset and sysconfig
>> handling.
>>
>> Tidspbridge uses a macro removed with this patch, for now the value
>> is hardcoded to avoid breaking compilation.
>
> You probably want to include people involved with power management on
> this, so maybe the linux-pm mailing list, and those involved with
> runtime-pm stuff (I think Rafael qualifies as the maintainer for this
> stuff, even if he's not listed in MAINTAINERS.)

Will do, I'll submit it again if no other comments are received.

Regards,

Omar
