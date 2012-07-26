Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab2GZUnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:43:04 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:33990 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2GZUnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:43:00 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] documentation, refactor, and cleanups (v2) for 3.7
Date: Thu, 26 Jul 2012 16:34:01 -0400
Message-Id: <1343334845-5340-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Attached are four patches that documented a bit more the P2M and MMU
code. And as well make some of the code cleaner and easier to read.


