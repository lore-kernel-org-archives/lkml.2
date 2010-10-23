Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756288Ab0JWRtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 13:49:16 -0400
Received: from vms173009pub.verizon.net ([206.46.173.9]:64654 "EHLO
	vms173009pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab0JWRtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 13:49:15 -0400
Date: Sat, 23 Oct 2010 13:48:56 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Christian Ruediger Bahls <lkml@qb352.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: intel_idle .. Was: __pm_runtime_resume() returns -1 Was:
 Regression in 2.6.36
In-reply-to: <20101023042607.GB449@pfau.e-technik1.uni-rostock.de>
Message-id: <alpine.LFD.2.00.1010231346110.2565@localhost.localdomain>
References: <AANLkTinPyg2ijrBydVyoGJiQJCpL7j1_vnyQWnx0eucz@mail.gmail.com>
 <20101022165734.d7ed2582.akpm@linux-foundation.org>
 <20101023042607.GB449@pfau.e-technik1.uni-rostock.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> and yes indeed booting with "intel_idle.max_cstate=0"
> makes the system work again

Please file a sighting here:
https://bugzilla.kernel.org/enter_bug.cgi?product=Power%20Management
component: intel_idle

and assign it to me.

thanks,
Len Brown, Intel Open Source Technology Center



