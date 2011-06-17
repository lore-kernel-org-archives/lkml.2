Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab1FQWBO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:01:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:47917 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1FQWBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:01:12 -0400
MIME-Version: 1.0
Message-ID: <b9f0ec1d-0dd7-43e5-8c24-26979ae4245c@default>
Date: Fri, 17 Jun 2011 15:00:55 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] xen: prepare tmem shim to handle frontswap
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DFBCEA4.0066:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad --

Please pull the following branch into your Xen for-linus tree
for the upcoming 3.1 window.

git://git.kernel.org/pub/scm/linux/kernel/git/djm/tmem.git stable/frontswap-tmemonly

The branch is based off of 3.0-rc1.

This single commit provides the shim code for frontswap for Xen
tmem (even though the core kernel frontswap patchset is not present
yet... the egg is before the chicken here.)

Diffstat:
 drivers/xen/Kconfig                      |    7 
 drivers/xen/Makefile                     |    2 
 drivers/xen/tmem.c                       |  170 +++++++++++++++++++--
 3 files changed, 166 insertions(+), 13 deletions(-

Dan Magenheimer (1):
      xen: prepare tmem shim to handle frontswap

Thanks,
Dan
