Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835Ab2BCI2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 03:28:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754658Ab2BCI17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 03:27:59 -0500
Date: Fri, 3 Feb 2012 13:57:48 +0530
From: Amit Shah <amit.shah@redhat.com>
To: luto@amacapital.net
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: vsyscall=emulate regression
Message-ID: <20120203082748.GB782@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm booting some latest kernels on a Fedora 11 (released June 2009)
guest.  After the recent change of default to vsyscall=emulate, the
guest fails to boot (init segfaults).

I also tried vsyscall=none, as suggested by hpa, and that fails as
well.  Only vsyscall=native works fine.

The commit that introduced the kernel parameter,

3ae36655b97a03fa1decf72f04078ef945647c1a

is bad too.

The host system is RHEL6, if that matters.

Please let me know if you need any more information or testing.

		Amit
