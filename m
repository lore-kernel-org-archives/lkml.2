Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0GFQBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 12:01:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50449 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326Ab0GFQBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 12:01:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Qgs1tE+Fipk676xx14UyiNK2ydt1mDXV5ECm9I9MeWiCyAdCmb9YUOOZQ1REZhqozd
         gmQIPa+wgzvK/3rMQA67AAp9kx43qjRx7lTqSSscg1LmmD5NB7yg4q5fxV5zogeXcheT
         F140wuNSZlthH4IsVOGgDVZUkNcruNO8xL+nY=
MIME-Version: 1.0
In-Reply-To: <4C2B960A.7090503@colorfullife.com>
References: <alpine.DEB.2.00.1006180940140.11575@router.home>
	<20100621200118.GA4021@nb-core2.darkstar.lan>
	<4C223657.3030507@colorfullife.com>
	<AANLkTimE_BeA3yiCovC0ckn_MbbH3lpgctLD8zD5ir6j@mail.gmail.com>
	<AANLkTinw8qzAkHTNB05PqfWMQmuya1Dq6AZCgz2nWx6_@mail.gmail.com>
	<4C251AFF.70803@colorfullife.com>
	<AANLkTilm19O8nPGHSzExdCOPWR2Cridxq_sjs_uRkd8E@mail.gmail.com>
	<4C2620F4.7030900@colorfullife.com>
	<AANLkTikSh0FZYPppDcF2YDoyDBkIZcAdTBj7iN_9Cta4@mail.gmail.com>
	<4C2B960A.7090503@colorfullife.com>
Date: Tue, 6 Jul 2010 18:01:45 +0200
Message-ID: <AANLkTikAhqIz56xfUBBuQStMq9FqQp1sVZwhZ_Y4XAm5@mail.gmail.com>
Subject: Re: 2.6.35-rc3: System unresponsive under load
From: Luca Tettamanti <kronos.it@gmail.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Julia Lawall <julia@diku.dk>, Andrew Morton <akpm@linux-foundation.org>,
       maciej.rutecki@gmail.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 9:07 PM, Manfred Spraul
<manfred@colorfullife.com> wrote:
> Attached is a new idea, could you try it with your httpd test?

Will test ASAP.

> Perhaps the race is actually a race in the user space:
> The exit path of semtimedop() does not contain an explicit memory barrier.
> For the kernel, it does not matter: It merely reads one integer value.
> If sysret is also no memory barrier, then user space might observe stale
> data.
>
> Which cpu do you have? I was unable to show any misbehavior on a Phenom X4.

Intel(R) Core(TM)2 Duo CPU     T7500  @ 2.20GHz

I also have a Phenom X4, but I'm currently waiting a replacement for the PSU...

Luca
