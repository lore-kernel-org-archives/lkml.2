Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751205Ab0GYEKA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 00:10:00 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:39325 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab0GYEJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 00:09:59 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 24 Jul 2010 21:09:21 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-laptop
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nathan Lynch <ntl@pobox.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] signalfd: fill in ssi_int for posix timers and message
 queues
In-Reply-To: <20100720211018.e586c7ce.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1007242104060.1470@davide-laptop>
References: <1278117528.21917.354.camel@localhost> <20100720154205.667e95aa.akpm@linux-foundation.org> <1279683859.3030.121.camel@localhost> <20100720211018.e586c7ce.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Jul 2010, Andrew Morton wrote:

> It's not a matter of a current application depending on current
> behaviour!  The problem is that an application written in 2018 which
> depends on the _new_ behaviour will not work on 2.6.34.
> 
> It wouldn't be the worst thing we've ever done to our long-suffering
> users, but it is a permanent cost of having screwed things up :(

While I agree it is a problem with the kernel compatibility handling, 
every time we add new features to an existing interface we end up in 
similar scenarios.
Nowadays a "require kernel >= X.Y.Z" is all but an uncommon case for 
userspace code.


- Davide

