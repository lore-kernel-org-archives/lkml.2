Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1CYWg5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:36:57 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:46993 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab1CYWgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:36:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=BTXkYPJNBSZdc1/UcQ7p1LKqalqxT7Si
	bsMGU4c/ndj2e2/qjU3bQpU1yP6BpjzdahrDnJdTwLju2i1Oogt18Lz3bAOENQ2P
	JiohFCGMtxFRQtHBvNCspstCJWDKmSpZkqFvawTgpM9z/Z0q8rNkjoMum3Epil7t
	O7+gjKpXPq0=
From: Junio C Hamano <junio@pobox.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Dario Faggioli <raistlin@linux.it>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Gregory Haskins <ghaskins@novell.com>, Mike Galbraith <efault@gmx.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] sched: leave sched_setscheduler earlier if possible.
References: <1300971618.3960.82.camel@Palantir>
 <1300976519.14261.141.camel@gandalf.stny.rr.com>
 <1301048910.2250.184.camel@laptop>
 <1301057573.14261.168.camel@gandalf.stny.rr.com>
 <1301058430.2250.211.camel@laptop>
Date: Fri, 25 Mar 2011 15:36:24 -0700
In-Reply-To: <1301058430.2250.211.camel@laptop> (Peter Zijlstra's message of
 "Fri, 25 Mar 2011 14:07:10 +0100")
Message-ID: <7vzkoi4yl3.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 967AC114-5730-11E0-B8C8-E8AB60295C12-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> Junio, know of any way to make git-diff do the same? The purpose is to
> skip labels as functions so that people stop doing stupid crap like
> indenting labels, eg.:
>
> void foo(void)
> {
>  again:

Perhaps "git help attributes" and look for "funcname"?
