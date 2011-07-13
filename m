Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1GMM3Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:29:24 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38632 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab1GMM3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:29:22 -0400
Date: Wed, 13 Jul 2011 14:29:17 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] signals: convert the IA32_EMULATION code to use
 set_current_blocked()
Message-ID: <20110713122917.GL2872@htj.dyndns.org>
References: <20110710192724.GA31755@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110710192724.GA31755@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 10, 2011 at 09:27:24PM +0200, Oleg Nesterov wrote:
> sys32_sigsuspend() and sys32_*sigreturn() change ->blocked directly.
> This is not correct, see the changelog in e6fa16ab
> "signal: sigprocmask() should do retarget_shared_pending()"
> 
> Change them to use set_current_blocked().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
