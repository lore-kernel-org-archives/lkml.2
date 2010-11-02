Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab0KBUIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 16:08:38 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:54132 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab0KBUIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 16:08:36 -0400
From: Vernon Mauery <vernux@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        Vernon Mauery <vernux@us.ibm.com>
Subject: [PATCH 0/2] ibm_rtl fixes
Date: Tue,  2 Nov 2010 13:08:09 -0700
Message-Id: <1288728491-2216-1-git-send-email-vernux@us.ibm.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pair of patches address two issues that were brought
to my attention.  The first is to remove the need for
constantly updating the driver whenever a new machine
with this capability is added.  The second fixes a bug
when run on a machine in UEFI mode.

Signed-off-by: Vernon Mauery <vernux@us.ibm.com>

--Vernon

ibm_rtl: Loosen the DMI criteria to all IBM machines
ibm_rtl: _RTL_ is not available in UEFI mode

 ibm_rtl.c |   32 +++++++-------------------------
 1 file changed, 7 insertions(+), 25 deletions(-)

