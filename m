Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2HOIGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 04:06:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56562 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2HOIFe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 04:05:34 -0400
Message-ID: <1345017919.31459.36.camel@twins>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kees Cook <keescook@chromium.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Date: Wed, 15 Aug 2012 10:05:19 +0200
In-Reply-To: <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
References: <20120726134748.GA20605@localhost>
	 <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	 <20120810015222.GA19286@localhost>
	 <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
	 <20120815030110.GA24836@localhost>
	 <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-14 at 22:56 -0700, Kees Cook wrote:
> So Oleg's suggestion of removing the locking around the reading of
> ->comm is wrong since it really does need the lock. 

There's tons of code reading comm without locking.. you're saying that
all is broken?
