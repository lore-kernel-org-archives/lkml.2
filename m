Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094Ab2CTS7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:59:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55341 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755777Ab2CTS7s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:59:48 -0400
Message-ID: <1332269976.18960.449.camel@twins>
Subject: Re: extreme system load [kswapd]
From: Peter Zijlstra <peterz@infradead.org>
To: Karol =?UTF-8?Q?=C5=A0ebesta?= <sebesta.karol@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-admin@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Date: Tue, 20 Mar 2012 19:59:36 +0100
In-Reply-To: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
References: <CA+pWcCZ28ByXuOu72FAAAQAPny3O0WDvd+vv1TryXw+9DMKwiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 10:08 +0100, Karol Šebesta wrote:
> We have a problem on our production machine with high CPU utilization
> caused by kswapd3 daemon. Server is 128GB of physical memory and 81GB
> of SWAP.
> 
> 
> # cat /etc/redhat-release
> Red Hat Enterprise Linux Server release 5.6 (Tikanga) 

That's a very very old kernel, I would suggest you upgrade to something
that has the reclaim rewrite Rik did to deal with large memory systems.

I think they're in RHEL6, but I'm sure Rik knows.

Also, since you're running this dinosaur, contact RHT, they're the only
ones that care about it -- but I guess you're going to get the same
suggestion.
