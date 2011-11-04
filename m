Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab1KDMVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 08:21:12 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:40238 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750766Ab1KDMVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 08:21:11 -0400
Date: Fri, 4 Nov 2011 12:21:06 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        linux-mips@linux-mips.org
Subject: Re: [PATCH 12/49] MIPS: irq: Remove IRQF_DISABLED
Message-ID: <20111104122106.GA7581@linux-mips.org>
References: <1319277421-9203-1-git-send-email-yong.zhang0@gmail.com>
 <1319277421-9203-13-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319277421-9203-13-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, queued for 3.3.  I resolved a conflict in dbdma.c and remove
one IRQF_DISABLED which had been missed in arch/mips/kernel/perf_event.c.

Thanks!

  Ralf
