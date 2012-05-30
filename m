Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113Ab2E3VsW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 17:48:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53512 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754181Ab2E3VsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 17:48:20 -0400
Date: Wed, 30 May 2012 17:48:09 -0400
From: Dave Jones <davej@redhat.com>
To: tglx@linutronix.de
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: NOHZ: local_softirq_pending 08
Message-ID: <20120530214809.GA19223@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, tglx@linutronix.de,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,
I've been seeing these messages more and more lately.
When I start a kernel build for eg, it seems to spew regularly..

May 30 17:42:00 [ 1030.651976] NOHZ: local_softirq_pending 08
May 30 17:42:16 [ 1046.579491] NOHZ: local_softirq_pending 08
May 30 17:42:16 [ 1047.230344] NOHZ: local_softirq_pending 08
May 30 17:42:33 [ 1063.751879] NOHZ: local_softirq_pending 08
May 30 17:42:33 [ 1063.796340] NOHZ: local_softirq_pending 08
May 30 17:43:00 [ 1090.776493] NOHZ: local_softirq_pending 08
May 30 17:43:00 [ 1090.836544] NOHZ: local_softirq_pending 08
May 30 17:43:00 [ 1090.880271] NOHZ: local_softirq_pending 08
May 30 17:43:04 [ 1095.291939] NOHZ: local_softirq_pending 08
May 30 17:43:04 [ 1095.335659] NOHZ: local_softirq_pending 08



According to git, you ratelimited this back in 2007 with the message
"until we found the root cause of that problem."

Is this an old problem that has returned ?

Maybe interesting note: Both machines I see this on regularly are Atom cpus,
and it's always '08'.


	Dave
