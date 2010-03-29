Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0C2I0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 04:26:24 -0400
Received: from ozlabs.org ([203.10.76.45]:34074 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858Ab0C2I0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 04:26:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] module: encapsulate percpu handling better and record percpu_size
Date: Mon, 29 Mar 2010 18:56:20 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; i686; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Valdis.Kletnieks@vt.edu,
       Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>
References: <24605.1268073053@localhost> <4B963441.40000@kernel.org> <4B976CBA.3070305@kernel.org>
In-Reply-To: <4B976CBA.3070305@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003291856.20637.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 08:26:10 pm Tejun Heo wrote:
> Better encapsulate module static percpu area handling so that code
> outsidef of CONFIG_SMP ifdef doesn't deal with mod->percpu directly
> and add mod->percpu_size and record percpu_size in it.  Both percpu
> fields are compiled out on UP.  While at it, mark mod->percpu w/
> __percpu.

Nice cleanup.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.
