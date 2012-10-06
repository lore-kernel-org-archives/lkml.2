Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab2JFG6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 02:58:47 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:40554 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab2JFG6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 02:58:46 -0400
Date: Sat, 6 Oct 2012 12:29:14 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] uprobes: Introduce copy_opcode(), kill
 read_opcode()
Message-ID: <20121006065914.GD27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120923201921.GA27424@redhat.com>
 <20120923201948.GA27453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120923201948.GA27453@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100606-3534-0000-0000-00000D8053DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-23 22:19:48]:

> No functional changes, preparations.
> 
> 1. Extract the kmap-and-memcpy code from read_opcode() into the
>    new trivial helper, copy_opcode(). The next patch will add
>    another user.
> 
> 2. read_opcode() becomes really trivial, fold it into its single
>    caller, is_swbp_at_addr().
> 
> 3. Remove "auprobe" argument from write_opcode(), it is not used
>    since f403072c6.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

