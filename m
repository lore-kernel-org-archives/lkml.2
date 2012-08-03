Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513Ab2HCNcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:32:48 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62504 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2HCNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:32:46 -0400
MIME-Version: 1.0
In-Reply-To: <501A2A6F.4030502@t-online.de>
References: <501A2A6F.4030502@t-online.de>
Date: Fri, 3 Aug 2012 09:32:44 -0400
Message-ID: <CADnq5_OVmCds-xaPB7VsOhLd-4QSVwq9nHHarvmy9mQ8T_sNpg@mail.gmail.com>
Subject: Re: [PATCH] drm: ignore disconnected <-> unknown status changes
From: Alex Deucher <alexdeucher@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 2, 2012 at 3:21 AM, Knut Petersen <Knut_Petersen@t-online.de> wrote:
> On an AOpen i915GMm-hfs the hotplug events generated
> by transitions between connector_status_unknown and
> connector_status_disconnected cause screen distortions.
>
> The attached patch cures the problem by disabling the
> generation of hotplug events in those cases. That should
> be safe for everybody as the only relevant changes are
> those from / to connector_status_connected.

Seems reasonable to me.  We should just drop unknown.

Reviewed-by: Alex Deucher <alexander.deucher@amd.com>

>
> cu,
>  Knut
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
