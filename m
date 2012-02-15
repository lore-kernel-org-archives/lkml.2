Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756287Ab2BOXos (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:44:48 -0500
Received: from usmamail.tilera.com ([206.83.70.75]:37843 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab2BOXop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:44:45 -0500
Message-ID: <4F3C4364.6020401@tilera.com>
Date: Wed, 15 Feb 2012 18:44:36 -0500
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>  <1327591185.2446.102.camel@twins>  <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>  <20120201170443.GE6731@somewhere.redhat.com>  <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>  <4F2AAEB9.9070302@tilera.com> <1328898816.25989.33.camel@laptop> <4F3C28AF.9080005@tilera.com> <alpine.DEB.2.00.1202151614510.28225@router.home>
In-Reply-To: <alpine.DEB.2.00.1202151614510.28225@router.home>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/2012 5:15 PM, Christoph Lameter wrote:
> On Wed, 15 Feb 2012, Chris Metcalf wrote:
>
>> The Tilera dataplane code is available on the "dataplane" branch (off of
>> 3.3-rc3 at the moment):
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git
> Looks like that patch is only for the tile architecture. Is there a
> x86 version?

No, we haven't looked at doing that yet.  Part of that would be moving
things that are now in arch-specific area (like the <asm/dataplane.h>
header) to include/linux/, etc.; since this patch isn't ready for merge
yet, there are plenty of cleanups like that we'd want to do.  Probably the
next step is to figure out how to integrate what Tilera has done with the
nohz cpuset stuff that Frederic has so we retain the best of both worlds.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

