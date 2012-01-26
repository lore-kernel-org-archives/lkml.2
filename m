Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870Ab2AZMjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 07:39:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37708 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab2AZMj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:29 -0500
Message-ID: <1327581558.2446.100.camel@twins>
Subject: Re: [RFC PATCH v1 1/2] sched: unified sched_powersavings sysfs
 tunable
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Indan Zupancic <indan@nul.nu>, Youquan Song <youquan.song@intel.com>,
        Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 26 Jan 2012 13:39:18 +0100
In-Reply-To: <4F214380.2040601@kernel.dk>
References: <20120116161740.29759.4679.stgit@localhost>
	    <20120116162241.29759.13220.stgit@localhost>
	   <1327503181.2614.76.camel@laptop> <4F212DFF.8060802@kernel.dk>
	  <1327576091.2446.87.camel@twins> <4F21386C.5000809@kernel.dk>
	 <1327579450.2446.95.camel@twins> <4F214380.2040601@kernel.dk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 13:13 +0100, Jens Axboe wrote:
> Yep, looks good to me, and an improvement for me not to carry this
> code
> that doesn't really belong there. 

I'll take this as an ACK from you and slam the patch in my 3.4 queue.
Yell if I misconstrued your intent.

Thanks!
 
