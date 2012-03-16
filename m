Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161871Ab2CPAlx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:41:53 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59174
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1161859Ab2CPAl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:41:28 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0003] drivers: hv
Date: Thu, 15 Mar 2012 17:48:13 -0700
Message-Id: <1331858893-775-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set further enhances the KVP functionality for Linux
guests:

	1. Supports most of the Win8 KVP protocol.
	2. Supports operations on all the pools.

This is a re-send of the series sent on March10. I have made 
changes to address comments Dan Carpenter had posted.

Regards,

K. Y
