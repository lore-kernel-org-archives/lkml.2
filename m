Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751041Ab1IUUic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:38:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:60460 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab1IUUib convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:38:31 -0400
Subject: Re: s2ram broken (perf)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@elte.hu>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Date: Wed, 21 Sep 2011 22:35:03 +0200
In-Reply-To: <4E7A47E9.3020100@suse.cz>
References: <4E7A47E9.3020100@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316637303.24750.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 22:24 +0200, Jiri Slaby wrote:
> Hi,
> 
> this commit:
> commit 144060fee07e9c22e179d00819c83c86fbcbf82c
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Mon Aug 1 12:49:14 2011 +0200
> 
>     perf: Add PM notifiers to fix CPU hotplug races
> 
> breaks resume from s2ram for me, paradoxically. The text which was on
> the console before suspend appears when I resume. But the system hangs
> hard at that point. Reverting that commit on the top of -next helps.

bah.. nor did it fix the problem that was reported apparently... best to
back out and see if I can actually reproduce on something. I hate
developing on laptops :/


