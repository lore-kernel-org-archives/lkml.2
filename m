Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab1DVVAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 17:00:47 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:59026
	"HELO p3plsmtps2ded02-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752969Ab1DVVAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 17:00:45 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [RESEND] [PATCH 00/18] Staging: hv: Cleanup-storage-drivers-phase-III 
Date: Fri, 22 Apr 2011 14:13:00 -0700
Message-Id: <1303506780-1872-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a resend of a previously sent patch-set.

This patch-set deals with some of the style isues in blkvsc_drv.c. We also
get rid most of the "dead code" in this file:

	1) Get rid of most of the forward declarations in this file.
	   The only remaining forward declarations are to deal with 
	   circular dependencies.

	2) Get rid of most of the dead code in the file. Some of
	   the functions in this file are place holders - they are not
	   fuly implementedi yet (blkvsc_ioctl(), blkvsc_media_changed(). 
	   We have retained some comments/dead code, to help us in the
	   final implementation.

Regads,

K. Y 


