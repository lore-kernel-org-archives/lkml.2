Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1HDPsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 11:48:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:57900 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1HDPs2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 11:48:28 -0400
Subject: Re: select_task_rq_fair: WARNING: at kernel/lockdep.c
 match_held_lock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org
In-Reply-To: <20110804153752.GA3562@swordfish.minsk.epam.com>
References: <20110804141306.GA3536@swordfish.minsk.epam.com>
	 <1312470358.16729.25.camel@twins>
	 <20110804153752.GA3562@swordfish.minsk.epam.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 04 Aug 2011 17:47:47 +0200
Message-ID: <1312472867.16729.38.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-04 at 18:37 +0300, Sergey Senozhatsky wrote:
> > > [  132.794685] WARNING: at kernel/lockdep.c:3117 match_held_lock+0xf6/0x12e()

Just to double check, that line is:

                if (DEBUG_LOCKS_WARN_ON(!hlock->nest_lock))

in your kernel source?
