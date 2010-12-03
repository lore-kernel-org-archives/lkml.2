Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0LCWHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:07:09 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35762 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006Ab0LCWHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:07:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YD62aIvI2fSZpc0KVERfX8kaOYguVr2Gajy24VrPZHshUo/Ghs2bqbCY15yvzJ4/w2
         aeRA1NHE0pelvVKt9yWUQ28XtMrx3/hLY87Z92RRc/5BRAZalaXeoXKy4LqlwiHsmUxr
         +qH0Jnc2loVOSVdEfew3M6WlG9Pir5qG8hmic=
Message-ID: <4CF96A05.40908@gmail.com>
Date: Fri, 03 Dec 2010 23:07:01 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.13) Gecko/20100916 SeaMonkey/2.0.8
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andrej Ota <andrej@ota.si>, linux-kernel@vger.kernel.org, gvs@zemos.net,
        Rami Rosen <ramirose@gmail.com>, netdev <netdev@vger.kernel.org>
Subject: Re: unable to handle kernel NULL pointer dereference in skb_dequeue
References: <0fe401cb92e7$85ba2260$912e6720$@si>	 <1291381791.2897.250.camel@edumazet-laptop>	 <aa43945b38cee751a8231084866b074d@192.168.253.23> <1291387595.2897.350.camel@edumazet-laptop>
In-Reply-To: <1291387595.2897.350.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Le vendredi 03 décembre 2010 à 15:37 +0100, Andrej Ota a écrit :
>>>> Patch that works for me is below. Now I only hope I haven't
>>>> (re)introduced a memory leak...
>>
>>> Problem comes from commit 55c95e738da85 (fix return value of
>>> __pppoe_xmit() method)
...
> Rami, could you re-explain the rationale of your patch ?

I guess we could revert it in the meantime: it seems there might be
at least three threads (including bugzilla) with this problem.

Jarek P.
