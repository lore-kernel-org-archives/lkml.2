Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1GVUfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:35:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54743 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932090Ab1GVUfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:35:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110722133220.0baf2199@nehalam.ftrdhcpuser.net>
References: <CA+55aFxakA2U+oMJ1T7awTYa+p6xp9N0aCbfrUqgkF7BJ8gnQw@mail.gmail.com>
 <4E29CB5B.4040408@unsolicited.net> <CA+55aFy1FnVGH4C_0T8fXwZPUdz5-SCczMwy1K8kydLwTx89RQ@mail.gmail.com>
 <4E29D326.7070403@candelatech.com> <20110722133220.0baf2199@nehalam.ftrdhcpuser.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Jul 2011 13:35:16 -0700
Message-ID: <CA+55aFwX55HhzyPsb5vx-=xkHpWJBH0481ZFWcXnNzH1M6zhdg@mail.gmail.com>
Subject: Re: Linux 3.0 release
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Ben Greear <greearb@candelatech.com>, David <david@unsolicited.net>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 1:32 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
>
> The workqueue code should have a fallback and not try and
> do anything if being called from IRQ.

Fair enough. Especially since one of the *points* of workqueues is
indeed to schedule stuff from irqs and that cannot be done
immediately.

Tejun?

                  Linus
