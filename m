Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab1AKPZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:25:46 -0500
Received: from freeflow.nu ([178.79.134.28]:51831 "EHLO freeflow.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932192Ab1AKPZp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:25:45 -0500
Subject: Re: [PATCH] one more lock on memory hotplug (Re: [PATCH] slub: Fix
 sysfs circular locking dependency
From: Pekka Enberg <penberg@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1101110841230.8657@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org>
	 <alpine.DEB.2.00.1101050943120.13032@router.home>
	 <alpine.DEB.2.00.1101051108520.14761@router.home>
	 <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
	 <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com>
	 <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com>
	 <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com>
	 <alpine.DEB.2.00.1101061107500.8655@router.home>
	 <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.1101070922100.3014@router.home>
	 <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com>
	 <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com>
	 <1294475323.5248.74.camel@jaguar>
	 <alpine.DEB.2.00.1101101014470.12243@router.home>
	 <alpine.DEB.2.00.1101101230190.11969@chino.kir.corp.google.com>
	 <4D2BFAA9.2050200@kernel.org>
	 <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.1101110841230.8657@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Tue, 11 Jan 2011 17:25:42 +0200
Message-ID: <1294759542.5248.197.camel@jaguar>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I picked up both patches in slab.git in 'slub/hotplug' branch and queued
them for linux-next. Andrew, just holler if you want me to send them to
you; otherwise I'll send them to Linus myself.

			Pekka

