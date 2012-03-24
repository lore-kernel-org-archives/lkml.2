Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2CXQol (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 12:44:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:52500 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2CXQoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 12:44:39 -0400
Date: Sat, 24 Mar 2012 20:43:35 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Richard Weinberger <richard@nod.at>, Paul Mundt <lethal@linux-sh.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        John Stultz <john.stultz@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        uclinux-dist-devel@blackfin.uclinux.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        linux-mm@kvack.org
Subject: Re: [PATCH 07/10] um: Should hold tasklist_lock while traversing
 processes
Message-ID: <20120324164335.GA4955@lizard>
References: <20120324102609.GA28356@lizard>
 <20120324103030.GG29067@lizard>
 <1332593303.16159.28.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1332593303.16159.28.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2012 at 01:48:23PM +0100, Peter Zijlstra wrote:
> On Sat, 2012-03-24 at 14:30 +0400, Anton Vorontsov wrote:
> > Traversing the tasks requires holding tasklist_lock, otherwise it
> > is unsafe. 
> 
> No it doesn't, it either requires tasklist_lock or rcu_read_lock().

Well, currently the code does neither. :-)

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
