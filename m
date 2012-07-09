Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2GIUSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:18:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50871 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2GIUSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:18:33 -0400
From: Benjamin Segall <bsegall@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH 14/16] sched: make __update_entity_runnable_avg() fast
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	<20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
	<1341416463.19870.6.camel@laptop> <1341422408.19870.12.camel@laptop>
Date: Mon, 09 Jul 2012 13:18:29 -0700
In-Reply-To: <1341422408.19870.12.camel@laptop> (Peter Zijlstra's message of
	"Wed, 04 Jul 2012 19:20:08 +0200")
Message-ID: <xm26fw90zo16.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct, the sum is 1..n. The maximum was chosen as 516/46742 because
that is the point when the approximation of loop + fixed point math
being used reaches a maximum, even if the ideal y^n series would cap out
slightly differently.
