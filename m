Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2A1T2v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 14:28:51 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:3314 "EHLO
	mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751916Ab2A1T2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 14:28:50 -0500
X-IronPort-AV: E=Sophos;i="4.71,585,1320620400"; 
   d="scan'208";a="129243510"
Date: Sat, 28 Jan 2012 20:28:48 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: question about drivers/gpu/drm/drm_ioc32.c
Message-ID: <alpine.DEB.2.02.1201282026500.1973@hadrien>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the function compat_drm_getclient, I have the impression that the 
structure c32 is copied to user level with the field idx uninitialized?

julia
