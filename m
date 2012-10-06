Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964Ab2JFHZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 03:25:46 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37465 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab2JFHZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 03:25:43 -0400
Date: Sat, 6 Oct 2012 12:55:57 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: Don't return success if alloc_uprobe()
 fails
Message-ID: <20121006072557.GH27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194201.GA11319@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194201.GA11319@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12100607-3534-0000-0000-00000D806E3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-09-30 21:42:01]:

> If alloc_uprobe() fails uprobe_register() should return ENOMEM, not 0.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

