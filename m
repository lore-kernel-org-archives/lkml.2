Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab1LJSa1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 13:30:27 -0500
Received: from wavehammer.waldi.eu.org ([82.139.201.20]:51216 "EHLO
	wavehammer.waldi.eu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1LJSaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 13:30:01 -0500
From: Bastian Blank <waldi@debian.org>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: konrad.wilk@oracle.com
Subject: [PATCH 0/6] V3, Move stuff out of xenfs
Date: Sat, 10 Dec 2011 19:29:45 +0100
Message-Id: <1323541791-18006-1-git-send-email-waldi@debian.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v2:
- Rename xenbusd to xenbus_backend
- Register xenbus_backend device only if ring is local
- Use more correct error value: EPERM

Bastian

