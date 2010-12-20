Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536Ab0LTKhM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 05:37:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:43034 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab0LTKhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 05:37:10 -0500
Subject: Re: [PATCH RFC tip/core/rcu 13/20] rcu: increase
 synchronize_sched_expedited() batching
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
In-Reply-To: <4D0DD3D2.4030606@kernel.org>
References: <20101217205433.GA10199@linux.vnet.ibm.com>
	 <1292619291-2468-13-git-send-email-paulmck@linux.vnet.ibm.com>
	 <4D0CDD93.7040907@kernel.org> <20101218201419.GD2143@linux.vnet.ibm.com>
	 <4D0DD3D2.4030606@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 20 Dec 2010 11:31:20 +0100
Message-ID: <1292841080.2708.134.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-19 at 10:43 +0100, Tejun Heo wrote:
> 
> I see, then would something like the following work?
> 
>  (int)((unsigned)(a) - (unsigned)(b)) < 0 

Note that there is lots of kernel code that does the above and
variations thereof and expects it to work.


