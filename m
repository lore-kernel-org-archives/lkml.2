Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab2J0Wgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 18:36:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759547Ab2J0Wgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 18:36:44 -0400
Date: Sun, 28 Oct 2012 00:36:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: linux-kernel@vger.kernel.org
Subject: [Q] .readable_reg() not verified during read?
Message-ID: <Pine.LNX.4.64.1210280034310.4378@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:phkB0c6HyTBkvbUNcxrj+hQrx+DynSCbIu3pN2HoTjM
 t0Y6BbJn+Nm7iIx3t27RFQGyLKTP23AaXHQvy+vklnLspVJsOv
 sBQwaIw04ovyL7KPv6aVmbRfddXMeCZCCtxEbq/8woMN6pAicU
 y2shZ69TR7bK0C+dK8vfsleIO/Ovp+GfhYtzRhDG9MgwV8JE4+
 P67fE/ug2LS/yTdkUTayKfzWBxuomrGg49J7vD3Q2lVISjRxZ0
 sUgyokircaElxP9byXNtXzyrih8sTPOiHDD5brTLS83m3kHVSh
 RfKsEZSpZXpE7A3vpHYVMCQsRJ6uT5kBdJjpIiVrRsgVkWa+v0
 QgF1M3jIx3fCmFpTd3KRTdxo4PsL+FqLqnyNglrJYIhq1ij3ub
 zvbz8Y0AY1t9Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark

Looking at regmap.c it looks like the .readable_reg() callback is not 
consulted when performing a register read, e.g. in _regmap_raw_read(). Is 
this intentional? If yes - why?

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
