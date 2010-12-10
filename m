Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0LJVae (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 16:30:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63139 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0LJVac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 16:30:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qpjaYbzYGozC38AR0ldpl263kNz0izhVCBtdTXpsejqN1ZyfXKl9DblCEUbOf9txCp
         pWobmbNVNpLx9zmJm8LRkxLUQobiGCsart52vJ2EjapRQiIeBgqSJKja8oVGkc65h5F1
         3Lr1UFczqgoeSO0obw3HqAaXyhxOSewa/n5/c=
Message-ID: <4D029BF1.6020709@gmail.com>
Date: Fri, 10 Dec 2010 22:30:25 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.13) Gecko/20100916 SeaMonkey/2.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: nuclearcat@nuclearcat.com, eric.dumazet@gmail.com, andrej@ota.si,
        linux-kernel@vger.kernel.org, gvs@zemos.net, ramirose@gmail.com,
        netdev@vger.kernel.org
Subject: Re: unable to handle kernel NULL pointer dereference in skb_dequeue
References: <aa43945b38cee751a8231084866b074d@192.168.253.23>	<1291387595.2897.350.camel@edumazet-laptop>	<201012102151.04983.nuclearcat@nuclearcat.com> <20101210.121845.70177370.davem@davemloft.net>
In-Reply-To: <20101210.121845.70177370.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
> Date: Fri, 10 Dec 2010 21:51:04 +0200
...
>> Is there any plans to queue any patch to stable?
>> pppoe is almost dead in 2.6.36.*
> 
> I'll deal with it for -stable once I evaluate this patch for upstream,
> which I haven't even gotten to yet.

This patch is here:
http://patchwork.ozlabs.org/patch/75095/

But IMHO it's buggy for the reason I mentioned. Since Andrej
didn't respond yet I'd suggest reverting of the offending
commit 55c95e738da85. If you agree with that but e.g. too busy,
let me know.

Jarek P.
