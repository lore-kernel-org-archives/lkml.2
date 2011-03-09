Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1CIXJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:09:05 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:20825 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab1CIXJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:09:03 -0500
X-Greylist: delayed 545 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Mar 2011 18:09:03 EST
Subject: [PATCH 0/2] hpsa: add resettable sysfs host attribute  
To: james.bottomley@hansenpartnership.com
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        smcameron@yahoo.com, thenzl@redhat.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com
Date: Wed, 09 Mar 2011 16:59:56 -0600
Message-ID: <20110309225822.26877.94051.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At Redhat's request, this adds a sysfs host attribute to indicate whether
the reset_devices kernel parameter can be honored by the device.  This enables 
kexec tools to warn the user if they attempt to designate a non-resettable device
as the dump device.  If the device is not resettable, kdump won't work.

---

Stephen M. Cameron (2):
      hpsa: move device attributes to avoid forward declarations
      hpsa: export resettable host attribute


 Documentation/scsi/hpsa.txt |   12 ++
 drivers/scsi/hpsa.c         |  276 ++++++++++++++++++++++++-------------------
 2 files changed, 164 insertions(+), 124 deletions(-)

--
-- steve

