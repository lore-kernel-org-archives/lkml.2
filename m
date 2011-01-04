Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab1ADK4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 05:56:01 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:40060 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1ADKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 05:55:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=w6B0SYDxHWaMZlMY1ybvMHi8l4GSw643f+yuLyViTw50UieZLptP38SGmusziESpOS
         JrtBZZeNW4k+pezYaNN32SEQCgVagQIcKS0GQGygD2UZzI6XiogecvTd1Kjx6l8zKKzi
         giEZNmaP3DH0uPStIDY89rI3QaUyuNU8X0NQM=
Subject: Re: [PATCH 1/3] sched: add __rcu annotation
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1294136267.2016.105.camel@laptop>
References: <4D22D4EE.3020604@cn.fujitsu.com>
	 <1294136267.2016.105.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 11:55:45 +0100
Message-ID: <1294138545.3579.53.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 04 janvier 2011 à 11:17 +0100, Peter Zijlstra a écrit :

> I'm really starting to detest sparse (lock annotations), it keeps adding
> these annotations, but does it ever catch an actual bug?

Actually I caught at least one bug in networking (FIB code ?) thanks to
these __rcu annotations ;)

Cannot remember the exact bug, sorry ;)


