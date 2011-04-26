Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab1DZKHV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 06:07:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:39436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1DZKHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 06:07:18 -0400
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ
 related?)
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: sedat.dilek@gmail.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110424164331.GN2628@linux.vnet.ibm.com>
References: <20110422005046.GQ2235@linux.vnet.ibm.com>
	 <BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
	 <20110422150222.GA2300@linux.vnet.ibm.com>
	 <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
	 <20110423210539.GI2628@linux.vnet.ibm.com>
	 <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
	 <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
	 <BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
	 <20110424062728.GM2628@linux.vnet.ibm.com>
	 <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
	 <20110424164331.GN2628@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 12:06:57 +0200
Message-ID: <1303812417.20212.239.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-24 at 09:43 -0700, Paul E. McKenney wrote:
> 
> Peter, any thoughts on what I might have done wrong to get the scheduler
> into a state where it was ignoring a runnable realtime task? 

Not really, the only thing I can think of is something like poking at
task->state while its sleeping. One you set it to TASK_RUNNING wakeups
will be ignored since its already running ;-)
