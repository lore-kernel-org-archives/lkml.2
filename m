Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917Ab2HPQEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:04:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20850 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733Ab2HPQEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:04:40 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] Xen-SWIOTLB fies (v3) for v3.7.
Date: Thu, 16 Aug 2012 11:54:43 -0400
Message-Id: <1345132488-27323-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since changeset: v2: https://lkml.org/lkml/2012/7/31/337
 - fixed smatch warnings (add __ref and appropiate header files.

Besides that it is exactly like the one I posted in July except
it has been tested more extensively.

