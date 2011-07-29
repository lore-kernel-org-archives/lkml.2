Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1G2JEZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 05:04:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:50631 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755698Ab1G2JEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 05:04:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/CrA1/7dzCZLVNlrtlpRphn/Y0p7Sas1PaJ5tpbo
	blusXOx1iK7m8q
Subject: Re: [PATCH] sched: Remove WAKEUP_PREEMPT feature check in
 entity_tick
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        "mingo@elte.hu" <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1311926218.5890.215.camel@twins>
References: <1311846203.3938.1555.camel@minggr.sh.intel.com>
	 <20110729062158.GA8971@zhy>
	 <1311922180.3938.1573.camel@minggr.sh.intel.com>
	 <20110729070356.GA10420@zhy>
	 <1311924975.3938.1583.camel@minggr.sh.intel.com>
	 <20110729074635.GB10420@zhy>  <1311926218.5890.215.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 11:04:18 +0200
Message-ID: <1311930258.5500.36.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-29 at 09:56 +0200, Peter Zijlstra wrote:

> And I'm starting to think we should just kill all of WAKEUP_PREEMPT I
> don't think we ever want to disable it anyway..

Agreed.  You have to be really into pain to flip that switch.

	-Mike


