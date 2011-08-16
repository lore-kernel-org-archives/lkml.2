Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1HPT0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:26:36 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1HPT0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:26:35 -0400
Date: Tue, 16 Aug 2011 21:26:29 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linas Vepstas <linasvepstas@gmail.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
Message-ID: <20110816192629.GB2803@mtj.dyndns.org>
References: <20110816190858.GA4890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816190858.GA4890@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 09:08:58PM +0200, Oleg Nesterov wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
> 
> eeh_event_handler() thread is created by the worker kthread, and thus
> it doesn't need the soon-to-be-deprecated daemonize().
> 
> Note: looks like eeh_event_wq can be static and it can do all work
> itself without kernel_thread().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Yeay!  Nice series.  How do you wanna route these?  Through -mm?

Thanks.

-- 
tejun
