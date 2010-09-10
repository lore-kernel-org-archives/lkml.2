Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0IJKlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 06:41:51 -0400
Received: from 87-119-183-14.tll.elisa.ee ([87.119.183.14]:3601 "EHLO
	bazspaz.fatphil.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751356Ab0IJKlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 06:41:50 -0400
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: tony.luck@intel.com
Cc: fenghua.yu@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] ia64: possible module unwind table optimisation
Date: Fri, 10 Sep 2010 13:40:43 +0300
Message-Id: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This move-to-front linked list optimisation was a huge win on ARM, so I 
checked for other architectures which manage their module unwind tables
in a similar way.

Alas I have no way to test this patch.

Phil
