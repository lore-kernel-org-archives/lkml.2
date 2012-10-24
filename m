Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226Ab2JXKuY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:50:24 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61323 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758120Ab2JXKuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:50:23 -0400
Date: Wed, 24 Oct 2012 12:49:50 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-kernel@vger.kernel.org
cc: Joe Perches <joe@perches.com>, linux-sh@vger.kernel.org
Subject: [Q] "console=" command line ignored?
Message-ID: <Pine.LNX.4.64.1210241226060.31768@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:MyDWLEBnMO7t/i/FdNfnNTg+5pRngisyaWtVoyqV1p8
 Pb9SqTJFJtfWzLfGFC9eD/cJJLEcCFsP4ZbnTgnXe+TXpCKd/I
 ToUBOIioWP3oV1kyVRBT6/iAa6qKdrnfTA33vuYZux29vt0NOG
 B1yDhkVDN53q+T108ULvAegW6pmVo/Y50q4R4yApPG/eAFF8X1
 xdLvSJG2Jja7aTKBz1/1JSMemSwdtuT0S087n7pCEfJeG1YO+A
 WXMjiPs3NCLIgk08ciGNl79hlaVgFvxRXtaCVrzP9ZE68pOmph
 78fpCEIo46u5VhFKSUd2y2X3RZRmfjTAhY8zymXXEjsAabfpg9
 kzMI0Io7Iy8a+M5JUhsJDYhHWBSNesmihcjNs+JBv+wcuNaEdE
 nt6trqp5pa8ng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I cannot seem to force selection of a serial console by specifying 
"console=ttySC0..." on the command line with modern (yesterday's "next") 
kernels. The kernel insists on

console [tty0] enabled

The reason might also well be, that the respective "sh-sci" driver is 
only registered later. I'll try to look at this in more detail - since 
when this is broken and how the registration order looked before. This is 
just a first heads-up in case someone has a solution immediately at hand.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
