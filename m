Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab1KRSUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:20:08 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:30213 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab1KRSUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:20:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation for sysfs attributes for 3.3 (xen related)
Date: Fri, 18 Nov 2011 13:19:51 -0500
Message-Id: <1321640393-19708-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.1
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4EC6A1D4.00FD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please accept the following two patches that describe the
SysFS of some of the Xen drivers. Thank you.

David Vrabel (2):
      xen: document balloon driver sysfs files
      xen: document backend sysfs files

 Documentation/ABI/stable/sysfs-bus-xen-backend     |   75 +++++++++++++++++++
 .../ABI/stable/sysfs-devices-system-xen_memory     |   77 ++++++++++++++++++++
 2 files changed, 152 insertions(+), 0 deletions(-)


