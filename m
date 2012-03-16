Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422933Ab2CPOys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 10:54:48 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:46031
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1422910Ab2CPOyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 10:54:41 -0400
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0003] drivers: hv
Date: Fri, 16 Mar 2012 08:01:29 -0700
Message-Id: <1331910089-5207-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set further enhances the KVP functionality for Linux
guests:

	1. Supports most of the Win8 KVP protocol.
	2. Supports operations on all the pools.

This is a re-send of the series sent on March15. I have made 
changes to address comments Dan Carpenter had posted.

Regards,

K. Y
