Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760196Ab0G3SQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:16:28 -0400
Received: from smtp-out.google.com ([74.125.121.35]:1886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760053Ab0G3SQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:16:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=MivxUCCQHXjOGNfg3i7t3A1z+rbB6sTbqdX3p26evKhaC0AmzHCwmULn3QlKrmHwS
	V5cwJvbHE0UIXQ29yps5g==
MIME-Version: 1.0
In-Reply-To: <20100730194359.e6761b78.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
	<20100729142245.4AA5.A69D9226@jp.fujitsu.com>
	<20100729142429.58b49dce.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.00.1007291027410.7491@tigran.mtv.corp.google.com>
	<20100730090146.7e65d1c1.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTing_3HoC9oWNheHJPgQWp2xmN6-C_cyZxoJUqc_@mail.gmail.com>
	<20100730131432.891df49a.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTimvZSFHCZZ=SCQF8DtZ3vVYJmA=4qWs2SDAgvKi@mail.gmail.com>
	<20100730194359.e6761b78.kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 30 Jul 2010 11:16:16 -0700
Message-ID: <AANLkTimFX5QBwD3b5D6ZPV6rdnB2i+bAxK4ZRxTQkvCK@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Hugh Dickins <hughd@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 3:43 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> plz wait until the next week..I found I can't post today ;(
>
> Maybe trying my quick hack patch (posted) will be enough small for
> backporting etc.

Absolutely.  I didn't intend my broader anxieties to distract from
your immediate scan_swap_map() fix.  If Ondrej finds that it does in
fact fix the corruption he's been seeing since 2.6.31, then I'd like
your fix to go straight to Linus for 2.6.35: once swap is 50% full,
your case is rather too likely to occur; whereas I'm worrying about
correctness in unlikely hypothetical circumstances.  But please do
credit Ondrej, and make clear that you're fixing an observed
corrution; and feel free to add my
Acked-by: Hugh Dickins <hughd@google.com>

Hugh
