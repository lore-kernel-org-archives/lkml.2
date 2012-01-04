Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800Ab2ADOeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:34:18 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57292 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763Ab2ADOeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:34:16 -0500
Date: Wed, 4 Jan 2012 15:34:12 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Vinod Koul <vinod.koul@intel.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [PATCH 0/2] dma: shdma: clear buffers on reset
Message-ID: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:C2DgkF3vFwd3RjPIVCKbmH+3/RY0vESbyCON8OVKvLo
 PHWiZfu5jgjBW8RT8MoBbxbrvA9E25dwNY0Y5u6ixX/yUZFr26
 nGdNWIOPPvh1wrlGAFBV1ZUhGddWf/Z1UBtD1RlmeaOMz4pXJ9
 i54K3nYBj5t2KsnGuSzr+iVGKuezz7PBGFkqlqEcDfyKhy/Xki
 0uofvHWhcAwdHp47r0LGI/GEcWuUCk8THzCHQTxZ+k+02GKFoC
 +gmYOFW7oW+XffVQKplidZGT1p+V+M+4JnQADjrvsKsim7m4X9
 2sefz2yLkwXzyiGhbg17qvxK98jjOG9DFdsp5Vrgu7bURJSBjA
 Lp3Niei/x0/F9RUg84ihoJQRVrprW6Ohp75tv/ROAMZpiEJ7kS
 rPsF4BReD1rog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set fixes a runtime PM problem on shdma, whereby it fails to 
recover after the power domain has been switched off.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
