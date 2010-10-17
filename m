Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab0JQOEs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 10:04:48 -0400
Received: from canuck.infradead.org ([134.117.69.58]:37770 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab0JQOEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 10:04:47 -0400
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
From: Peter Zijlstra <peterz@infradead.org>
To: Eric Paris <eparis@parisplace.org>
Cc: eparis@redhat.com, Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
In-Reply-To: <1287323960.1998.360.camel@laptop>
References: <20101016065206.GO4681@dastard>
	 <20101016192027.GA6883@infradead.org>
	 <1287295077.3020.83.camel@localhost.localdomain>
	 <1287313332.1998.172.camel@laptop>
	 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
	 <1287323960.1998.360.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 16:04:32 +0200
Message-ID: <1287324272.1998.366.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 15:59 +0200, Peter Zijlstra wrote:

> Me, I'm henceforth making sure to have CONFIG_IMA disabled...

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 security/integrity/ima/Kconfig |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index b6ecfd4..278362c 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -24,6 +24,10 @@ config IMA
 	  whether or not critical system files have been modified.
 	  Read <http://www.usenix.org/events/sec04/tech/sailer.html>
 	  to learn more about IMA.
+
+	  When built-in (Y) this option will consume considerable
+	  resources even when effectively disabled.
+
 	  If unsure, say N.
 
 config IMA_MEASURE_PCR_IDX

