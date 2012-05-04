Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204Ab2EDR2j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 13:28:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab2EDR2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 13:28:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120503085034.032327158@linutronix.de>
References: <20120503085034.032327158@linutronix.de> <20120503083859.991965503@linutronix.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: dhowells@redhat.com, LKML <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch V2 03/31] task_allocator: Use config switches instead of magic defines
Date: Fri, 04 May 2012 18:28:25 +0100
Message-ID: <13401.1336152505@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner <tglx@linutronix.de> wrote:

> +config ARCH_TASK_STRUCT_ALLOCATOR
> +	bool
> +
> +config ARCH_THREAD_INFO_ALLOCATOR
> +	bool

With comments saying what they mean...

David
