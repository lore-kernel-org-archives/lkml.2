Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab1KXGpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 01:45:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:60938 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab1KXGpg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 01:45:36 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.01.1111231025180.8000@trent.utfs.org>
References: <20111121131531.GA1679@x4.trippels.de>
	<1321890510.10470.11.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111121161036.GA1679@x4.trippels.de>
	<1321894353.10470.19.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<1321895706.10470.21.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111121173556.GA1673@x4.trippels.de>
	<1321900743.10470.31.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	<20111121185215.GA1673@x4.trippels.de>
	<20111121195113.GA1678@x4.trippels.de>
	<1321907275.13860.12.camel@pasglop>
	<alpine.DEB.2.01.1111211617220.8000@trent.utfs.org>
	<alpine.DEB.2.00.1111212105330.19606@router.home>
	<1321948113.27077.24.camel@edumazet-laptop>
	<1321999085.14573.2.camel@pasglop>
	<alpine.DEB.2.01.1111221511070.8000@trent.utfs.org>
	<1322007501.14573.15.camel@pasglop>
	<alpine.DEB.2.01.1111222145470.8000@trent.utfs.org>
	<CAOJsxLGWTRuwQ04Mg26fNhZEmo7yVXG5vSZgF7Q5GESCk65odA@mail.gmail.com>
	<alpine.DEB.2.00.1111230907330.16139@router.home>
	<alpine.DEB.2.01.1111231025180.8000@trent.utfs.org>
Date: Thu, 24 Nov 2011 08:45:33 +0200
X-Google-Sender-Auth: lRqk0uM1jXyuXBCzUhB7NCj4K0o
Message-ID: <CAOJsxLHhxLGKwuBO=e2+c5bu4i32Hr8ztWifVtxhwYS9BR0cxQ@mail.gmail.com>
Subject: Re: slub: use irqsafe_cpu_cmpxchg for put_cpu_partial
From: Pekka Enberg <penberg@kernel.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Christoph Lameter <cl@linux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Alex,Shi" <alex.shi@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 23 Nov 2011 at 09:14, Christoph Lameter wrote:
>> I think he only tested the patch that he showed us.

On Wed, Nov 23, 2011 at 8:33 PM, Christian Kujau <lists@nerdbynature.de> wrote:
> Yes, that's the (only) one I tested so far. I did some overnight testing
> (rsync'ing to the external disk again) for 6hrs and ran "slabinfo" every
> 30s during the run: http://nerdbynature.de/bits/3.2.0-rc1/oops/slabinfo-1.txt.xz
>
> The machine is still up & running. So for me, your patch fixes it!
>
>  Tested-by: Christian Kujau <lists@nerdbynature.de>

Applied, thanks!
