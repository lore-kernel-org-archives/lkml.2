Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025Ab0JAUhU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:37:20 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:38160 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0JAUhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:37:18 -0400
X-AuthUser: davidel@xmailserver.org
Date: Fri, 1 Oct 2010 13:37:08 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@ubuntu
To: Robin Holt <holt@sgi.com>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: max_user_watches overflows on 16TB system.
In-Reply-To: <20101001200143.GR14064@sgi.com>
Message-ID: <alpine.DEB.2.00.1010011335400.2305@ubuntu>
References: <20101001200143.GR14064@sgi.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Oct 2010, Robin Holt wrote:

> 
> Following a boot of a 16TB system, we noticed that the max_user_watches
> sysctl was negative.  Is there any downside to converting that to a
> static long and handling the fallout from the change?  I believe that
> fallout includes changing the definition of epoll_watches over to an
> atomic_long_t as well.
> 
> Alternatively should we just limit max_user_watches to INT_MAX?

2B watches looks an acceptable limit to me, at least for now.
Nobody complained about not having enough of them so far.


- Davide


