Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab0DBUsi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 16:48:38 -0400
Received: from toro.web-alm.net ([62.245.132.31]:44742 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753798Ab0DBUsa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 16:48:30 -0400
Message-Id: <20100402204018.575140584@osadl.org>
User-Agent: quilt/0.48-1
Date: Fri, 02 Apr 2010 22:40:18 +0200
From: Carsten Emde <C.Emde@osadl.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arjan van de Veen <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pradyumna Sampath <pradysam@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       RT-users <linux-rt-users@vger.kernel.org>,
       Carsten Emde <C.Emde@osadl.org>
Subject: [PATCH 0/2] Convert message queue timeouts to hrtimer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The message queue system calls that may timeout, mq_timedsend() and
mq_timedreceive(), still use the old jiffie-based timer interface.
Convert them to hrtimer.

The first patch provides the hrtimer infrastructure, the second patch
does the actual conversion to hrtimer.

	Carsten.
