Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab2HFOy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 10:54:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52464 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756453Ab2HFOyY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 10:54:24 -0400
Message-ID: <1344264832.27828.65.camel@twins>
Subject: Re: [PATCH] Revert "futex: Mark get_robust_list as deprecated"
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        dvhart@linux.intel.com, paul.gortmaker@windriver.com, jkosina@suse.cz,
        rob@landley.net, Randy Dunlap <rdunlap@xenotime.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        kernel-hardening@lists.openwall.com, spender@grsecurity.net,
        keescook@chromium.org, tglx@linutronix.de,
        Cyrill Gorcunov <gorcunov@openvz.org>, xemul@parallels.com,
        stable@vger.kernel.org, #@programming.kicks-ass.net,
        3.4.x@programming.kicks-ass.net
Date: Mon, 06 Aug 2012 16:53:52 +0200
In-Reply-To: <1344000593-18794-1-git-send-email-richard@nod.at>
References: <1344000593-18794-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-03 at 15:29 +0200, Richard Weinberger wrote:
> get_robust_list has at least two valid use cases.
> 1. checkpoint/restore in userspace
> 2. post mortem analysis 

Shouldn't this then also be added as a comment somewhere near the
implementation to avoid a repeat of this deprecate / undeprecate cycle?
