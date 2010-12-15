Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892Ab0LOLv6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 06:51:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44755 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345Ab0LOLv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 06:51:57 -0500
Date: Wed, 15 Dec 2010 12:51:54 +0100
From: Andi Kleen <andi@firstfloor.org>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101215115153.GB22304@basil.fritz.box>
References: <20101214152259.67896960@suzukikp>
 <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
 <20101215110446.157bbb25@suzukikp>
 <4D088C6C.8020800@kernel.org>
 <20101215165626.715007b5@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101215165626.715007b5@suzukikp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) A process can trigger a core synchronously, upon an event, say a signal 
> handler and continue from there. gcore would require a fork(), which is not 
> safe to use from a signal handler.

Why is it not safe for a signal?

>From the kernel side it should be. glibc may do some funky things
on fork, but you could always call the syscall directly.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
