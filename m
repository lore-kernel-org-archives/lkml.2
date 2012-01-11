Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab2AKHE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:04:27 -0500
Received: from mail4.comsite.net ([205.238.176.238]:27328 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab2AKHEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:04:25 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.21.127.101;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v6 3/8] tile: move tile to use generic on_each_cpu_mask
In-Reply-To: <1326040026-7285-4-git-send-email-gilad@benyossef.com>
References: <1326040026-7285-4-git-send-email-gilad@benyossef.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 01:04:12 -0600
X-Originating-IP: 71.21.127.101
Message-ID: <1326265452_1660@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 8 Jan 2012 about 11:28:05 EST, Gilad Ben-Yossef wrote:
> The API is the same as the tile private one, so just remove
> the private version of the functions

Except their up version also forgot local_irq_disable and local_irq_enable
like the arm.

Also as I said, merge 1-3 after review to avoid bisection build errors.

milton
