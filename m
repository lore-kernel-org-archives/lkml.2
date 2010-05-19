Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab0ESPpA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:45:00 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:64518 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab0ESPo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:44:58 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 May 2010 11:44:58 EDT
X-IronPort-AV: E=Sophos;i="4.53,264,1272859200"; 
   d="scan'208";a="97735692"
Subject: [GIT PULL] xen suspend resume fix.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: xen-devel <xen-devel@lists.xensource.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, <stable@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 19 May 2010 16:35:24 +0100
Message-ID: <1274283324.14939.209.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit aff67593b7fb2efa1ba17eb07ded96519b6b7cc1:
  Ian Campbell (1):
        xenbus: do not hold transaction_mutex when returning to userspace

are available in the git repository at:

  git://xenbits.xensource.com/people/ianc/linux-2.6.git for-jeremy/saverestore

Ian Campbell (1):
      xen: ensure timer tick is resumed even on CPU driving the resume

 arch/x86/xen/suspend.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

(this is based on xen.git#bugfix branch. I didn't base on 2.6.32 since
the prerequisite patches were only in 2.6.33 and 2.6.32.2. this is not
an area with a great deal of churn so it should merge around ok)

