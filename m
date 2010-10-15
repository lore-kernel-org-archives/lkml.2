Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab0JOU6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:58:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:60582 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756291Ab0JOU6y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:58:54 -0400
Subject: Re: [PATCH 5/9] jump label: Add
 register_jump_label_key/unregister_jump_label_key
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jason Baron <jbaron@redhat.com>
In-Reply-To: <20101015201036.923619508@goodmis.org>
References: <20101015200949.134732894@goodmis.org>
	 <20101015201036.923619508@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Oct 2010 22:58:10 +0200
Message-ID: <1287176290.1998.114.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-15 at 16:09 -0400, Steven Rostedt wrote:
>  
>  static inline void jump_label_lock(void) {}
>  static inline void jump_label_unlock(void) {}
> +static inline void register_jump_label_key(unsigned long key) {}
> +static inline void unregister_jump_label_key(unsigned long key) {}
> 
shouldn't we call that jump_label_register_key() and co?
