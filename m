Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab1JCPU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:20:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:42728 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755885Ab1JCPUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <CAKTCnzmM1sNqf4udk+osgYgY6zk8tQYx7DN0K02MBHuRCOYShQ@mail.gmail.com>
References: <CAA879TP_uNBd871yVFy1_dk_-5siOwtK8xM_D8MzYqJW2vFnUA@mail.gmail.com>
 <CA+55aFxBp0GjPujpt=JYWLC3mjBeSiCn8=jfpPxJHo4bTejhDA@mail.gmail.com> <CAKTCnzmM1sNqf4udk+osgYgY6zk8tQYx7DN0K02MBHuRCOYShQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 3 Oct 2011 08:20:33 -0700
X-Google-Sender-Auth: t5H37G0yYbtHhifU9lLJGOWG7qU
Message-ID: <CA+55aFzW-E7=Mgtm7uUWLh7GtTxmkWWLpwc9CcWqG3vgVtOHTw@mail.gmail.com>
Subject: Re: taskstats root only breaking iotop
To: Balbir Singh <bsingharora@gmail.com>
Cc: Guillaume Chazarain <guichaz@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 7:52 AM, Balbir Singh <bsingharora@gmail.com> wrote:
>>
>
> Namespaces came in later, much later after taskstats. I think your
> biased and not even thinking about your bias.

Umm. Yes, I'm biased. I'm biased as hell by the fact that I reported
the taskstats namespace breakage with a suggested approach to fix it,
and never heard back from anybody involved with it.

And yes, you were cc'd on that.

> What was badly designed?

The fact that it had no security what-so-ever? Unlike /proc, which at
least has the *structure* for security, even if it then often for
historical reasons leaves things a bit too open.

                           Linus
