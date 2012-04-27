Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab2D0Vtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 17:49:45 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42225 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031Ab2D0Vtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 17:49:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/2] PM / QoS / Domains: Fix and optimization
Date: Fri, 27 Apr 2012 23:46:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204272346.44145.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This series is on top of the PM domains governor functions fixup patches
posted recently:

http://marc.info/?l=linux-pm&m=133538218801804&w=4
http://marc.info/?l=linux-pm&m=133538220601826&w=4
http://marc.info/?l=linux-pm&m=133538218801805&w=4

Patch [1/2] is a fix that I think should be applied anyway.  Patch [2/2],
though, is an RFC.  It is a bit subtle, although perhaps that's not immediately
visible at first sight.  Patch [2/2] hasn't been tested yet, but I have
verified that it builds.

Comments welcome!

Thanks,
Rafael

