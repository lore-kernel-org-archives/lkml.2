Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab0G0Xvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:51:32 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:41550 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0G0Xvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:31 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>
Subject: [PATCH 00/15] hpwdt: make NMI code a config option (+ other cleanup)
Date: Tue, 27 Jul 2010 17:50:48 -0600
Message-Id: <1280274663-9160-1-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwpdt includes an NMI-decoding feature, but the watchdog interface is quite
usable without it. This patchset makes it possible to build hpwdt without the
NMI functionality, as well as some general cleanup.

 Kconfig |   22 +++++--
 hpwdt.c |  181 ++++++++++++++++++++++++++++++++++++----------------------------
 2 files changed, 119 insertions(+), 84 deletions(-)

