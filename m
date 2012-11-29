Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab2K2Th0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:37:26 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37956 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751013Ab2K2ThX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:37:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] cifs: neatening and embedded module size reduction
Date: Thu, 29 Nov 2012 11:37:17 -0800
Message-Id: <cover.1354217746.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches (3):
  cifs: Remove unused cEVENT macro
  cifs: Make CIFS_DEBUG possible to undefine
  cifs: Enable Kconfig control of CIFS_DEBUG

 fs/cifs/Kconfig      |   10 ++++++-
 fs/cifs/cifs_debug.h |   74 +++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 31 deletions(-)

-- 
1.7.8.112.g3fd21
