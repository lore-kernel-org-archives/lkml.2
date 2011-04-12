Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab1DLCib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:38:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24780 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab1DLCia (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 11 Apr 2011 22:38:30 -0400
Date: Mon, 11 Apr 2011 22:38:17 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, haitao.shan@intel.com,
        nikai@nikai.net
Subject: [GIT PULL] (xen) stable/bug-fixes-rc2 for 2.6.39-rc3
Message-ID: <20110412023817.GA22534@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4DA3BB1D.00F1:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Linus,

Please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/bug-fixes-rc2

changes since git commit 0ce790e7d736cedc563e1fb4e998babf5a4dbc3d
Linus Torvalds (1):
    Linux 2.6.39-rc1

Which provides for handling of the XSAVE functionality (disable), tone
down some of the WARNings in the Xen MMU, and fix a simple mismatch of
return values. Small bugs.

Jeremy Fitzhardinge (1):
      xen: just completely disable XSAVE

Konrad Rzeszutek Wilk (1):
      xen/debug: Don't be so verbose with WARN on 1-1 mapping errors.

Nicolas Kaiser (1):
      xen: events: fix error checks in bind_*_to_irqhandler()

Shan Haitao (1):
      xen: Allow PV-OPS kernel to detect whether XSAVE is supported

 arch/x86/xen/enlighten.c |   21 +++++++--------------
 arch/x86/xen/mmu.c       |    4 ++--
 drivers/xen/events.c     |    6 ++----
 3 files changed, 11 insertions(+), 20 deletions(-)
