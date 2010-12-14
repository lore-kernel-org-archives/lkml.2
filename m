Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab0LNQUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 11:20:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48335 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758112Ab0LNQUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 11:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <4D079541.3090405@kernel.org>
References: <20101214152259.67896960@suzukikp> <AANLkTim3h2EBcEUP19S2Z0CKA7Oe3k5pB=4LjXsOR3F9@mail.gmail.com>
 <4D079541.3090405@kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 08:19:56 -0800
Message-ID: <AANLkTi=wBLRLpGw+DUHTNwdFPOTkkTRwMQ17agVY1UVV@mail.gmail.com>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump infrastructure
To: Tejun Heo <tj@kernel.org>
Cc: "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 8:03 AM, Tejun Heo <tj@kernel.org> wrote:
>
> I think a better way would be adding a ptrace attach which is nestable
> and doesn't have the nasty side effect caused by the interactions
> between the implicit SIGSTOP and group stop.

Don't we already nest at least to some degree? At least you can strace
a gdb session or another strace, no?

                Linus
