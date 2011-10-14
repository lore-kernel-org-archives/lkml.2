Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab1JNWiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:38:10 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34757 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522Ab1JNWiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:38:08 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jeremy@goop.org
Subject: [PATCH] XEN_DOMAIN_MEMORY options.
Date: Fri, 14 Oct 2011 15:36:49 -0700
Message-Id: <1318631811-21559-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E98B9CD.004D:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Please find here patches for XEN_MAX_DOMAIN_MEMORY:

[PATCH 1/2] xen: Fix XEN_MAX_DOMAIN_MEMORY to be selectable
[PATCH 2/2] xen: Make XEN_MAX_DOMAIN_MEMORY have more sensible defaults for 32-bit builds

Best regards,
Maxim Uvarov.
