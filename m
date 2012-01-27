Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab2A0IVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 03:21:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:56694 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2A0IVy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 03:21:54 -0500
Message-ID: <1327652503.2446.128.camel@twins>
Subject: Re: [BUG] TASK_DEAD task is able to be woken up in special condition
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Yasunori Goto <y-goto@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
Date: Fri, 27 Jan 2012 09:21:43 +0100
In-Reply-To: <CAHGf_=pLJcoSuKZb+P0c_7uW16hO35cMkQfJQB1SUJt8uLkGYw@mail.gmail.com>
References: <1324633794.24803.48.camel@twins>
	 <20111223154137.GA27901@redhat.com>
	 <20111226172357.CE4D.E1E9C6FF@jp.fujitsu.com>
	 <20111226171151.GA4472@redhat.com> <4EFB8523.6080708@gmail.com>
	 <1327486224.2614.45.camel@laptop>
	 <CAHGf_=pLJcoSuKZb+P0c_7uW16hO35cMkQfJQB1SUJt8uLkGYw@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-26 at 16:21 -0500, KOSAKI Motohiro wrote:
> 
> Sorry for the delay. Yeah, I think this should work. (even though I
> don't understand __migrate_task() detail) 

__migrate_task() isn't a problem, its use of activate/deactivate is safe
but also superfluous so I removed it too.
