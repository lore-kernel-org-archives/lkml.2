Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab0KLLZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:25:40 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47640 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab0KLLZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bdC6hrQLm+CW6wx2nZEECoJ9TYg5b3S/WQ5lHJKRA4/OfdPlhTcskAToQXmboTtVaM
         YCvejseN2TKaAI3Y+H/xPRYJ0dc05VQHwzHAIrA3sq20MC3ZmNeteZ9fEJIyYyBN80cE
         Z+P3UoH+9NDvdoz+/z6M0i1JvpTpcr048ggaE=
Subject: Re: Kernel rwlock design, Multicore and IGMP
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Cypher Wu <cypher.w@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>
In-Reply-To: <AANLkTikHjGkq5FDoXHaUbRkpurmT3mSLiu8toqqRL4Gi@mail.gmail.com>
References: <AANLkTikvT=x9eBovn2-m6HLqk7wyXSAR3sc9jCQ0C6mL@mail.gmail.com>
	 <1289489007.17691.1310.camel@edumazet-laptop>
	 <AANLkTik93QUQxSDmwd4Qj-gXQiWWPzd68JPAYAHBAsHR@mail.gmail.com>
	 <20101112071323.GB5660@cr0.nay.redhat.com>
	 <1289546874.17691.1774.camel@edumazet-laptop>
	 <AANLkTikHjGkq5FDoXHaUbRkpurmT3mSLiu8toqqRL4Gi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 12 Nov 2010 12:25:33 +0100
Message-ID: <1289561133.3185.123.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 12 novembre 2010 à 19:10 +0800, Cypher Wu a écrit :

> I used to using that way, just seperate the call internal and
> external, with external one hold lock then call the internal one. But
> in that case ip_check_mc() is called indirectly from igmpv3_sendpack()
> and is not very clear how to give the different paramter?

I said that I was preparing a RCU patch, dont bother with this ;)

Should be ready in a couple of minutes.

Thanks


