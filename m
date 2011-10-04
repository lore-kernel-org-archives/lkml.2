Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab1JDWOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:14:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47186 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932820Ab1JDWOr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:14:47 -0400
Subject: Re: Quick review of -rt RCU-related patches
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.02.1110042322450.18778@ionos>
References: <20111004174755.GA4762@linux.vnet.ibm.com>
	 <alpine.LFD.2.02.1110042322450.18778@ionos>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 05 Oct 2011 00:13:18 +0200
Message-ID: <1317766398.32543.39.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-10-05 at 00:05 +0200, Thomas Gleixner wrote:
> I consider rcu_bh a bandaid for the nasty implict semantics of BH
> processing and I'm looking really forward to Peters analysis of the
> modern cpu local BKL constructs at RTLWS. 

You and me both! Oh wait.. :-)
