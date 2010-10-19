Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774Ab0JSU7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:59:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:47135 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757697Ab0JSU7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:59:20 -0400
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: pacman@kosh.dhis.org
Cc: Mel Gorman <mel@csn.ul.ie>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101019181021.22456.qmail@kosh.dhis.org>
References: <20101019181021.22456.qmail@kosh.dhis.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 07:58:43 +1100
Message-ID: <1287521923.2198.2.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 13:10 -0500, pacman@kosh.dhis.org wrote:
> 
> So what type of driver, firmware, or hardware bug puts a 16-bit 1000Hz
> timer
> in memory, and does it in little-endian instead of the CPU's native
> byte
> order? And why does it stop doing it some time during the early init
> scripts,
> shortly after the root filesystem fsck?
> 
> I have not yet attempted to repeat the experiment. If it is
> repeatable, I'll
> probe more deeply into those init scripts later. I'm looking hard at
> /etc/rcS.d/S11hwclock.sh 

Stinks of USB...

Ben.


