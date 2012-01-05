Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599Ab2AEPZS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:25:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:56807 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755536Ab2AEPZP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:25:15 -0500
Message-ID: <1325777082.2196.2.camel@twins>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they
 exist
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mel Gorman <mel@csn.ul.ie>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Date: Thu, 05 Jan 2012 16:24:42 +0100
In-Reply-To: <20120105144011.GU11810@n2100.arm.linux.org.uk>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	 <1325499859-2262-8-git-send-email-gilad@benyossef.com>
	 <4F033EC9.4050909@gmail.com> <20120105142017.GA27881@csn.ul.ie>
	 <20120105144011.GU11810@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-05 at 14:40 +0000, Russell King - ARM Linux wrote:
> I've been chasing that patch and getting no replies what so
> ever from folk like Peter, Thomas and Ingo. 

Holidays etc.. I _think_ the patch is good, but would really like
someone else to verify, its too simple to be right :-)

Thomas said he'd bend his brain around it, but he's been having holidays
as well and isn't back from them afaik.

As for completely reworking the whole hotplug crap, I'd fully support
that, there's a lot of duplication in the arch code that should be
generic code. Also lots of different ways to solve the same problem
etc.. lots of different bug too I bet.


