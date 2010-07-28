Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab0G1PwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 11:52:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53983 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab0G1PwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 11:52:12 -0400
MIME-Version: 1.0
In-Reply-To: <19398.1280323047@redhat.com>
References: <AANLkTikB9Msot4m_oaw+V+dvEg+SzyXHb0cqhKQqUtC2@mail.gmail.com> 
	<20100727155023.GF1967@jolsa.brq.redhat.com> <AANLkTineVrcffFWGxQ+EzYno6xvcNS9=M7hn_KddASnQ@mail.gmail.com> 
	<24865.1280249187@redhat.com> <18537.1280318862@redhat.com> 
	<19398.1280323047@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Jul 2010 08:51:14 -0700
Message-ID: <AANLkTinVkHtzMUkdE7S9J2cRu-gjUWm+noE=C0kwJZSw@mail.gmail.com>
Subject: Re: [PATCH] cred - synchronize rcu before releasing cred
To: David Howells <dhowells@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 6:17 AM, David Howells <dhowells@redhat.com> wrote:
>
> The attached patch should suffice to fix get_task_cred(), and should render
> Jiri's patch unnecessary.

Ok, I like this one. It seems to make things much simpler, and makes
sense to me.

Let's just hope it works ;) but modulo that, ACK.

                 Linus
