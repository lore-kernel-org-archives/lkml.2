Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0LUNZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 08:25:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48819 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab0LUNZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 08:25:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:x-virus-scanned:message-id:in-reply-to:references:date
         :subject:from:to:cc:user-agent:mime-version:content-type
         :content-transfer-encoding:x-priority:importance;
        b=TvgRi4uADMU9vys4DXl2Dve9ugLZoMTgDMjQtZprT9Knj3t212KaQB3hlPORCIOQAc
         0vnlNHzFfH0/SGk5bn8tAxZ3bTzt5ndwotr+RZvuhsea48dynMiKJ62/caL6rHuq6Sj6
         gLiOBcUF7l8Qrd6vPas3TunfkSfPAz+kAnfMc=
Message-ID: <cfea3ff472f0afa93787761050a6b637.squirrel@arekh.dyndns.org>
In-Reply-To: <20101221125934.GA13285@htj.dyndns.org>
References: <1292762975.2403.29.camel@localhost>
    <AANLkTimYx2Og1BG37wb0WZ0_U8WJjLKHMKgU45qycUaM@mail.gmail.com>
    <AANLkTikuKMLUoVnQsU6QNCnHBgOponJUngHGtyVHk1xK@mail.gmail.com>
    <4D0F8276.9070903@kernel.org> <20101221044050.GA25718@windriver.com>
    <20101221125934.GA13285@htj.dyndns.org>
Date: Tue, 21 Dec 2010 14:25:21 +0100
Subject: Re: [V2 PATCH] kthread_work: Make lockdep happy
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "Tejun Heo" <tj@kernel.org>
Cc: "Yong Zhang" <yong.zhang0@gmail.com>,
        "Andy Walls" <awalls@md.metrocast.net>, linux-kernel@vger.kernel.org,
        nicolas.mailhot@laposte.net, "Jarod Wilson" <jarod@redhat.com>,
        "Ingo Molnar" <mingo@redhat.com>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        "Hans Verkuil" <hverkuil@xs4all.nl>,
        "Andrew Morton" <akpm@linux-foundation.org>
User-Agent: SquirrelMail/1.4.21-1.fc14
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le Mar 21 décembre 2010 13:59, Tejun Heo a écrit :

> If somebody can confirm this makes lockdep behave correctly, I'll
> route it through the wq tree.

I can boot-test it if someone adds it to the rawhide kernel or a kernel that
can be downloaded from koji (don't really have the time to build kernels right
now)

-- 
Nicolas Mailhot

