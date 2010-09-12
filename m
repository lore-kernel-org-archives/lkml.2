Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0ILK25 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 06:28:57 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:45813 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab0ILK24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 06:28:56 -0400
Date: Sun, 12 Sep 2010 11:28:54 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: EeePC 900 reboots/hangs when using using perf -a -f -g
Message-ID: <20100912102854.GA7359@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On an EeePC 900 running 2.6.36rc3 I've been finding that the laptop
immediately reboots or hangs forever if I run

perf -a -f -g xset dpms force off

. I've got lockdep checking and stack overflow checking on but these
don't make any difference. Using only -a -f doesn't show the problem. I
have also found that disabling eeepc-laptop in the kernel config also
removes the problem.

Any suggestions?

-- 
Sitsofe | http://sucs.org/~sits/
