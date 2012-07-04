Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392Ab2GDWHZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 18:07:25 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53265 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755782Ab2GDWHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 18:07:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/4] PM / TPM: Convert platform TPM drivers to PM handling based on struct dev_pm_ops
Date: Thu, 5 Jul 2012 00:08:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, tpmdd-devel@lists.sourceforge.net,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201207050008.02097.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As per

http://marc.info/?l=linux-kernel&m=133996733422413&w=4

the following patches convert the platform TPM drivers to the PM handling
based on struct dev_pm_ops:

[1/4] Drop the (unused) pm_message_t argument of tpm_pm_suspend().
[2/4] tpm_atmel: Use struct dev_pm_ops for power management.
[3/4] tpm_tis: Use struct dev_pm_ops for power management.
[4/4] tpm_nsc: Use struct dev_pm_ops for power management.

Thanks,
Rafael
