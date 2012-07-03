Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805Ab2GCPst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:48:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39267 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab2GCPsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:48:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH] various Xen fixes for v3.6 (v1).
Date: Tue,  3 Jul 2012 11:40:34 -0400
Message-Id: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am working on some other bugs and perf issues - and while working I noticed
that both sparse and Coverity have reported some issues with Xen drivers.

Please see attached various bug-fixes that I am proposing for 3.6.

