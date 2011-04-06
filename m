Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756908Ab1DFVXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 17:23:05 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48420
	"HELO p3plsmtps2ded03-02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756858Ab1DFVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 17:23:04 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [RESEND] [PATCH 00/22] Staging: hv: Cleanup-storage-drivers-phase-III 
Date: Wed,  6 Apr 2011 14:34:15 -0700
Message-Id: <1302125655-10741-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest upstream merge changed struct block_device_operations:
This merge got rid of blkvsc_media_changed and introduced the
function blkvsc_check_events. This broke all the patches that
were sent after the tree was closed the last time. This is a resend of
this patch-set to account for this change in the kernel.

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


