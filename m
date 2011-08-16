Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1HPVbN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 17:31:13 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:48842 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752739Ab1HPVbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 17:31:12 -0400
Subject: Re: [PATCH] tomoyo: remove tomoyo_gc_thread()->daemonize()
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20110816183405.GA3257@redhat.com>
References: <20110816183405.GA3257@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Aug 2011 22:31:09 +0100
Message-ID: <1313530269.3436.208.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-16 at 20:34 +0200, Oleg Nesterov wrote:
> daemonize() is only needed when a user-space task does kernel_thread().
> 
> tomoyo_gc_thread() is kthread_create()'ed and thus it doesn't need
> the soon-to-be-deprecated daemonize().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Matt Fleming <matt.fleming@intel.com>


