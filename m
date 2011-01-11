Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab1AKOli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 09:41:38 -0500
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:25571 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932179Ab1AKOlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 09:41:37 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Y9MqFQIVM1lb4BTPqscS5aZacbddFqvyWRMUpwBaEyRmmVX
 oRhUxzXsExc6u8gSUf8l._lrGBh88.jO8YzAiQgUutBVlZd1PIAKgDBNIS.K
 qK7aGgHRvYgU_.KYCVMdf7KAP7Y3Atulwm.3kjmW3YuUn8AB5pnQWHqOi.kS
 q03oLBmO4WaO.jNxSQ2t5GOLK7JLuE2v.fpWl.7U8e3cwL4WnsAgNKHEmW4s
 GF83rrkJhlsMcwHa70ondnfHrcGM0tsMLGiUO0vR4TkPFGNQ9NcFwP3Yf5GH
 7fmhcZ.Lr17hZk9O0WmqvW9.HqQ4382EbFhy0_d6.46WUqyHna08-
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 11 Jan 2011 08:41:32 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] one more lock on memory hotplug (Re: [PATCH] slub: Fix
 sysfs circular locking dependency
In-Reply-To: <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1101110841230.8657@router.home>
References: <1294172717-6044-1-git-send-email-penberg@kernel.org> <alpine.DEB.2.00.1101050943120.13032@router.home> <alpine.DEB.2.00.1101051108520.14761@router.home> <AANLkTinft80dXqE-U=YDB23d9=BgXLCxJzgiA_gF4cVL@mail.gmail.com>
 <AANLkTinCZzJWYGnxXq_Nwv7QSkEV4Tg-te-1y0PCeRRY@mail.gmail.com> <AANLkTinQMahgVrWLxR0J6Zbh-_SPjxVJ-wuZt8B5TNjc@mail.gmail.com> <alpine.DEB.2.00.1101060019140.25879@chino.kir.corp.google.com> <alpine.DEB.2.00.1101061107500.8655@router.home>
 <20110107091106.aaa07abe.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.1101070922100.3014@router.home> <alpine.DEB.2.00.1101071227160.31653@chino.kir.corp.google.com> <AANLkTin6N2s1RN6PBX=f0v69Ny-NkEKk_iAgqscuYgMM@mail.gmail.com> <1294475323.5248.74.camel@jaguar>
 <alpine.DEB.2.00.1101101014470.12243@router.home> <alpine.DEB.2.00.1101101230190.11969@chino.kir.corp.google.com> <4D2BFAA9.2050200@kernel.org> <20110111164401.3b1e5d8a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Christoph Lameter <cl@linux.com>


