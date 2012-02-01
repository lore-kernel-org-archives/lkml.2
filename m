Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab2BAVT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:19:27 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:63444 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757466Ab2BAVTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] small fixes to 3.3 (and 3.2) CPU hotplug code. (v1)
Date: Wed,  1 Feb 2012 16:16:38 -0500
Message-Id: <1328131000-13485-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F29AC56.00BC,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I was playing with 'xm vcpu-set X N' I realized that the VCPU hotplug
code in 3.2 spews tons of messages. Found out that we were missing an preempt_*
call. While at it, I fixed also an annoying message ("XENBUS: Unable to ..")
that shows up during bootup.

Anyhow, these are going for 3.3 and CC-ing stable on the:
 [PATCH 1/2] xen/smp: Fix CPU online/offline bug triggering a BUG:

