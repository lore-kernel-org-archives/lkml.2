Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab1AUAkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 19:40:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:39634 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1AUAkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:40:11 -0500
X-AuthUser: davidel@xmailserver.org
Date: Thu, 20 Jan 2011 16:40:05 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Colin Walters <walters@verbum.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] Networking
In-Reply-To: <AANLkTik8dk1o2u+JxzsijYFxJ7Y3ZV16DUNkc-+SYPnu@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1101201638100.4677@davide-lnx1>
References: <20110119.180418.216749267.davem@davemloft.net> <AANLkTin32jUnBtHF-EAkSMnFQM6cTbn-G3NZQJ3xjTWU@mail.gmail.com> <1295559646.2613.35.camel@edumazet-laptop> <AANLkTikLY1B3=C2TjAbYKVHbub-aPeG2heaUBWRUAg=R@mail.gmail.com>
 <AANLkTin6GM5W0nmWgD1a-2FK=CvHk=P3o6CYe-sFe6c=@mail.gmail.com> <AANLkTin-RBwg+J4MqOm7A40-TFAJ1sp4e6tzi6OaobNi@mail.gmail.com> <AANLkTim71374Qb1TW5Lc8H+rpQNk5a25ARczHU-+cn=D@mail.gmail.com> <AANLkTik8dk1o2u+JxzsijYFxJ7Y3ZV16DUNkc-+SYPnu@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Linus Torvalds wrote:

> On Thu, Jan 20, 2011 at 4:02 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So far I only did a revert, I didn't see exactly _which_ of the wakeup
> > cases it was. But it's definitely that commit.
> 
> This patch - that adds all the appropriate POLLxxx flags - seems to
> fix it for me. Will commit. Anybody wants to review/ack?

I believe you can drop the POLLERR, otherwise looks good to me.


- Davide


