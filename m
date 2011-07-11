Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1GKJax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 05:30:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:19926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227Ab1GKJaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 05:30:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,514,1304319600"; 
   d="scan'208";a="24362855"
Date: Mon, 11 Jul 2011 10:30:47 +0100
From: Matt Fleming <matt.fleming@linux.intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: convert the IA32_EMULATION code to use
 set_current_blocked()
Message-ID: <20110711103047.22fc6f5c@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110710192724.GA31755@redhat.com>
References: <20110710192724.GA31755@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jul 2011 21:27:24 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> sys32_sigsuspend() and sys32_*sigreturn() change ->blocked directly.
> This is not correct, see the changelog in e6fa16ab
> "signal: sigprocmask() should do retarget_shared_pending()"
> 
> Change them to use set_current_blocked().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Looks simple enough.

Reviewed-by: Matt Fleming <matt.fleming@linux.intel.com>
