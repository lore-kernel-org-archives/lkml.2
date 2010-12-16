Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043Ab0LPR4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 12:56:12 -0500
Received: from www.tglx.de ([62.245.132.106]:56794 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284Ab0LPR4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 12:56:09 -0500
Date: Thu, 16 Dec 2010 18:55:10 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Richard Cochran <richardcochran@gmail.com>
cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>
Subject: Re: [PATCH V7 2/8] posix clocks: introduce a syscall for clock
 tuning.
In-Reply-To: <a93ce18c2987f7e102bc2ff5b12130211c222ea7.1292512461.git.richard.cochran@omicron.at>
Message-ID: <alpine.LFD.2.00.1012161848190.12146@localhost6.localdomain6>
References: <cover.1292512461.git.richard.cochran@omicron.at> <a93ce18c2987f7e102bc2ff5b12130211c222ea7.1292512461.git.richard.cochran@omicron.at>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Dec 2010, Richard Cochran wrote:

> A new syscall is introduced that allows tuning of a POSIX clock. The
> syscall is implemented for four architectures: arm, blackfin, powerpc,
> and x86.

Can you please split that patch into one providing the syscall itself
and for each architecture a separate one ?

Looks good otherwise.

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
