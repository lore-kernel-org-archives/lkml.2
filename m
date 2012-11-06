Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab2KFWZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:25:52 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42042 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864Ab2KFWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:25:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] Fix various compile errors/warnings on ARM with CONFIG_XEN_*=m
Date: Tue,  6 Nov 2012 17:13:00 -0500
Message-Id: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two patches that I was thinking for v3.7 to fix compile issues.

 [PATCH 1/2] xen/generic: Disable fallback build on ARM.

This one, requires Stefano's Ack:

 [PATCH 2/2] xen/arm: Fix compile errors when drivers are compiled as
