Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932888Ab2HPQAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:00:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30576 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756288Ab2HPQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:00:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] Fixes for v3.6 (v1).
Date: Thu, 16 Aug 2012 11:50:12 -0400
Message-Id: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I sent a git pull two days ago to Linus and then I realized yesterday
we still have two more bugs that should be fixed.

So these are two tiny fixes that I am going to propose for v3.6.

