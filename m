Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1BQSCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:02:19 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50790 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145Ab1BQSCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:02:17 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH -V3] Buffered write and writeable mmap support for 9P
Date: Thu, 17 Feb 2011 23:31:51 +0530
Message-Id: <1297965725-25603-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch series is on top of the last patchset i posted
http://thread.gmane.org/gmane.linux.kernel/1096376

Changes include
a) various fixes for 9p when caching is enabled
b) DirectIO support

-aneesh

