Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab2EBNuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:50:05 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61808 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754360Ab2EBNuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:50:02 -0400
MIME-Version: 1.0
In-Reply-To: <1335965318.22133.568.camel@edumazet-glaptop>
References: <1335964237-1139-1-git-send-email-levinsasha928@gmail.com> <1335965318.22133.568.camel@edumazet-glaptop>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Wed, 2 May 2012 15:49:41 +0200
Message-ID: <CA+1xoqfVQfPseoSuBLY99nx_BuXpoGD4X6_xKk9_BoG0Mo__jw@mail.gmail.com>
Subject: Re: [PATCH] net: l2tp: unlock socket lock before returning from l2tp_ip_sendmsg
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: davem@davemloft.net, jchapman@katalix.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 2, 2012 at 3:28 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Good catch, but please use existing code style in this function.
>
> rc = -EDESTADDRREQ;
> if (sk->sk_state != TCP_ESTABLISHED)
>        goto out;
>
> Also, please add in your commit message bug origin to ease stable team
> work (not counting reviewers work)
>
> Bug added in commit 2f16270f41e1 (l2tp: Fix locking in l2tp_ip.c)
>
> Really, given the amount of patches you already sent, you should already
> know that.
>
> Thanks
>
>

Understood. I'll resend.
