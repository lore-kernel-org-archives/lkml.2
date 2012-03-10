Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752952Ab2CJXZQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 18:25:16 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:52944
	"HELO p3plsmtps2ded02-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752423Ab2CJXZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 18:25:14 -0500
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        ohering@suse.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0000/0004] drivers: hv
Date: Sat, 10 Mar 2012 15:31:40 -0800
Message-Id: <1331422300-4330-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch-set further enhances the KVP functionality for Linux
guests:

	1. Supports most of the Win8 KVP protocol.
	2. Supports operations on all the pools.

Regards,

K. Y
