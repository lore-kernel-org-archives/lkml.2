Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab1GKJbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:31:23 -0400
Received: from mga11.intel.com ([192.55.52.93]:41411 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1GKJbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:31:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,514,1304319600"; 
   d="scan'208";a="26401482"
Date: Mon, 11 Jul 2011 10:31:10 +0100
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: convert the X86_32 code to use
 set_current_blocked()
Message-ID: <20110711103110.20018ac1@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110710192727.GA31759@redhat.com>
References: <20110710192727.GA31759@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 21:27:27 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> sys_sigsuspend() and sys_sigreturn() change ->blocked directly.
> This is not correct, see the changelog in e6fa16ab
> "signal: sigprocmask() should do retarget_shared_pending()"
> 
> Change them to use set_current_blocked().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
