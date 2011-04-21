Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1DUUdf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:33:35 -0400
Received: from mail.aknet.ru ([78.158.192.28]:47376 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753417Ab1DUUdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:33:33 -0400
Message-ID: <4DB0945A.7010903@aknet.ru>
Date: Fri, 22 Apr 2011 00:32:26 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [2/2]
References: <20110405151549.GB17490@redhat.com> <4D9B4265.6080403@aknet.ru> <20110405164557.GA23248@redhat.com> <4DADA22A.1010205@aknet.ru> <20110419155830.7ad33312@lxorguk.ukuu.org.uk> <4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk> <4DAEDC3F.5010208@aknet.ru> <20110420165023.GA24455@redhat.com> <4DB000A6.5060409@aknet.ru> <20110421201537.GB12248@redhat.com>
In-Reply-To: <20110421201537.GB12248@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

22.04.2011 00:15, Oleg Nesterov wrote:
> Stas, I bet you didn't test your patch.
Not with ptrace, yes. :(

>   If the old parent traces the child
What is "old parent" without reparenting?

> Oh. And I bet there are other problems. Say, exec can change the leader...
> Easy to fix, but note that we need more and more stupid pr_detached special
> cases.
>
> Stas, sorry. I am not going to looks at the next versions. Until you
> convince lkml we need this feature.
OK, if you think there are really to much cases
that I missed, then this patch might be really more
intrusive than I suspected.
I got tired of it too, so fare well. :)
Thanks for your time.
