Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759230Ab2EUVWN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:22:13 -0400
Received: from outbound-queue-1.mail.thdo.gradwell.net ([212.11.70.34]:50565
	"EHLO outbound-queue-1.mail.thdo.gradwell.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759098Ab2EUVWL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:22:11 -0400
X-Greylist: delayed 312 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2012 17:22:11 EDT
Subject: 3.4: Build failure for lpfc_scsi driver
From: Alex Buell <alex.buell@munted.eu>
Reply-To: alex.buell@munted.eu
To: Mailing Lists - Kernel Developers <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: One very high maintenance cat for company
Date: Mon, 21 May 2012 22:16:55 +0100
Message-ID: <1337635015.29025.41.camel@lithium.local.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-Gradwell-MongoId: 4fbab0ca.b5d5-1a4a-2
X-Gradwell-Auth-Method: mailbox
X-Gradwell-Auth-Credentials: postmaster@pop3.munted.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc1: warnings being treated as errors
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’
drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’

Easily fixed though but all the other warnings previously seen were fine
yet this module was compiled with warnings being treated as errors?
-- 
Tactical Nuclear Kittens
