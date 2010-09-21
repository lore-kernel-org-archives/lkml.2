Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725Ab0IUAUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 20:20:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52742 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051Ab0IUAUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 20:20:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: caiqian@redhat.com
Subject: Re: [Bug #17341] kdump regression compared to v2.6.35
Date: Tue, 21 Sep 2010 02:19:52 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <2140525299.1437291285028155909.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <2140525299.1437291285028155909.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009210219.52657.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 21, 2010, caiqian@redhat.com wrote:
> It had been fixed by Tejun already.
> 
> commit 477a3c33d1efa0342a74bd02da2e049191993e2c
> Author: Tejun Heo <tj@kernel.org>
> Date:   Tue Aug 31 10:54:35 2010 +0200
> 
>     workqueue: fix GCWQ_DISASSOCIATED initialization
>     
>     init_workqueues() incorrectly marks workqueues for all possible CPUs
>     associated.  Combined with mayday_mask initialization bug, this can
>     make rescuers keep trying to bind to an offline gcwq indefinitely.
>     Fix init_workqueues() such that only online CPUs have their gcwqs have
>     GCWQ_DISASSOCIATED cleared.

Thanks, closing.

Rafael
