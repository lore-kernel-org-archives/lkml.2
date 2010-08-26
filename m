Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab0HZWpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 18:45:39 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:52202 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab0HZWpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 18:45:35 -0400
X-AuthUser: davidel@xmailserver.org
Date: Thu, 26 Aug 2010 15:45:33 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: Shawn Bohrer <shawn.bohrer@gmail.com>
cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hrtimer: make epoll_wait() use the hrtimer range
 feature
In-Reply-To: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
Message-ID: <alpine.DEB.2.00.1008261543470.25446@makko.or.mcafeemobile.com>
References: <1281307532-3235-1-git-send-email-shawn.bohrer@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Aug 2010, Shawn Bohrer wrote:

> This make epoll use hrtimers for the timeout value which prevents
> epoll_wait() from timing out up to a millisecond early.
> 
> This mirrors the behavior of select() and poll().

I saw this now, since I got notifications from Andrew's patch machine.
Is this really needed?
Is that really worth the extra code in the fast path?
Aren't we breaking existing behavior?
I have some doubts.


- Davide


