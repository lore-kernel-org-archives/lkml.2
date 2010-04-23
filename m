Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab0DWIBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:01:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:50709 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756489Ab0DWIBg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:01:36 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19/J4lSijh/b4/NRg0df0OO3QGJO/O3BACBldAhSG
	LKnJHq53EyiubW
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: dri-devel@lists.sourceforge.net
Subject: post 2.6.34-rc5 breaks integrated intel graphic at ThinkPad T400
Date: Fri, 23 Apr 2010 10:01:33 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004231001.33587.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68999999999999995
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

something between c81eddb..d5a3045  breaks my system. As soon as xdm or startx 
is started, the (external) screen is black. Neither Ctrl-Alt-Del nor any SysRq 
keys are working anymore.

The system has a GM45 chip set.

-- 
MfG/Sincerely
Toralf Förster

pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

