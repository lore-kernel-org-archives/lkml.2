Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2G3T2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:28:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61061 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab2G3T2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:28:31 -0400
Date: Mon, 30 Jul 2012 21:28:18 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] serial: sh-sci: fix compilation breakage (3.6)
Message-ID: <Pine.LNX.4.64.1207302114440.28003@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:du7lg3x3B6vqoipXGoEwYo0ACLm1LoorMv3EnEaOgjv
 jyzL8doDRWeXyvh8+XTbOaGeOWBHH8uHGDbQ/IUyex7ig4uxmm
 WsQ8Vo3evHQpgTtyvpMHuqq5rTN93QRQcI6bXDyCEFPkNOHo/x
 ulzrNtyLCSLTIYmUrVLoufK0Awn5SQ4YC2GrAs7k39M0lP0spd
 2ET6wYX1utYmk1IqCOQNb/MK6tgDfk3nCSbYU/LgMVAPe5Rntv
 PuDqRi7vNiOUp4ObL1izj7XqCuYX3ju7Psy28oul6oOsfPKo09
 uJY3npIsaMs106yDswL09eH35/NYEgWe5IUnJ3ZCRFHCKZjxUv
 rJXhR+fNi8K+FJEDtTSB1yfEZk60mrYyZDls/ITnizVyfagkF1
 WQFfW/TDD8k0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

as has been reported in this

http://thread.gmane.org/gmane.linux.kernel/1294256/focus=16001

thread, currently sh-sci doesn't comiple in the mainline and in -next if 
CONFIG_SERIAL_SH_SCI_DMA is enabled. This patch series fixes this 
breakage.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
