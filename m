Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab1I2VQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 17:16:31 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:64475 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438Ab1I2VQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 17:16:29 -0400
From: Maxim Uvarov <maxim.uvarov@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, eparis@redhat.com
Subject: [PATCH] audit: dynamically allocate audit_names when not enough spaceis in the names array 
Date: Thu, 29 Sep 2011 14:15:23 -0700
Message-Id: <1317330924-11080-1-git-send-email-maxim.uvarov@oracle.com>
X-Mailer: git-send-email 1.7.4.1
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E84E02C.0095:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

Are there any reasons why this patch is not in mainline?
https://www.redhat.com/archives/linux-audit/2010-March/msg00010.html

I upped it to 3.0.3 version.

Best regards,
Maxim.

