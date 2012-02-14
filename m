Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760147Ab2BNMWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 07:22:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754702Ab2BNMWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 07:22:23 -0500
Date: Tue, 14 Feb 2012 17:52:05 +0530
From: Amit Shah <amit.shah@redhat.com>
To: luto@amacapital.net
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: vsyscall=emulate regression
Message-ID: <20120214122205.GA29418@amit.redhat.com>
References: <20120203082748.GB782@amit.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203082748.GB782@amit.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 03 Feb 2012 [13:57:48], Amit Shah wrote:
> Hello,
> 
> I'm booting some latest kernels on a Fedora 11 (released June 2009)
> guest.  After the recent change of default to vsyscall=emulate, the
> guest fails to boot (init segfaults).
> 
> I also tried vsyscall=none, as suggested by hpa, and that fails as
> well.  Only vsyscall=native works fine.
> 
> The commit that introduced the kernel parameter,
> 
> 3ae36655b97a03fa1decf72f04078ef945647c1a
> 
> is bad too.

I suggest we revert 2e57ae0515124af45dd889bfbd4840fd40fcc07d till we
track down and fix the vsyscal=emulate case.

		Amit
