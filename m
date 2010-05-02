Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab0EBPJH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 May 2010 11:09:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:48448 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755529Ab0EBPJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 May 2010 11:09:04 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19bvnsPkHBbiqgk104GpiYeHdLQ5aeODD+OwEbANA
	WHYCNsX7Azhur1
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn, corbet@lwn.net
Subject: viafb suspend & resume, v2
Date: Sun,  2 May 2010 15:17:30 +0000
Message-Id: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68000000000000005
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second version of this patch series. It is forward ported to apply
on Jon's current viafb-posted branch. Furthermore the engine is only
(re)started if the mmio space is mapped.
There are still issues left especially device configuration and it does not yet
integrate nicely in the new structure of the driver. However it is in a state
where it shouldn't hurt anyone but could be useful for some people.


Thanks,

Florian Tobias Schandinat


Deepak Saxena (1):
      Minimal support for viafb suspend/resume

Florian Tobias Schandinat (3):
      viafb: restore display on resume
      viafb: make suspend and resume work (on all machines?)
      viafb: fix hardware acceleration for suspend & resume

