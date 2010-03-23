Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab0CWOqz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:46:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753978Ab0CWOqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:46:54 -0400
To: Soeren Sandmann <sandmann@daimi.au.dk>
Cc: Andi Kleen <andi@firstfloor.org>, Joerg Roedel <joro@8bytes.org>,
       Ingo Molnar <mingo@elte.hu>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, zhiteng.huang@intel.com,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from host side
References: <1268717232.2813.36.camel@localhost>
	<1268969929.2813.184.camel@localhost> <20100319082122.GE12576@elte.hu>
	<20100319172903.GI13108@8bytes.org> <20100321184300.GB25922@elte.hu>
	<20100322101451.GK13108@8bytes.org> <20100322105927.GB3483@elte.hu>
	<20100322114744.GC1940@8bytes.org>
	<ye88w9j2n2y.fsf@camel23.daimi.au.dk>
	<878w9jdu7m.fsf@basil.nowhere.org>
	<ye84ok72kxi.fsf@camel23.daimi.au.dk>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Tue, 23 Mar 2010 10:46:00 -0400
In-Reply-To: <ye84ok72kxi.fsf@camel23.daimi.au.dk> (Soeren Sandmann's message of "23 Mar 2010 15:04:57 +0100")
Message-ID: <y0mwrx3umdz.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soeren Sandmann <sandmann@daimi.au.dk> writes:

> [...]
>         - What is going on inside QEMU? 
>         - Which client is the X server servicing?
>         - What parts of a python/shell/scheme/javascript program is
>           taking the most CPU time?
> [...]

These kinds of questions usually require navigation through internal
data of the user-space process ("Where in this linked list is this
pointer?"), and often also correlating them with history ("which
socket/fd was most recently serviced?").

Systemtap excels at letting one express such things.

- FChE
