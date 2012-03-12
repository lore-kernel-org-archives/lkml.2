Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713Ab2CLWWf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:22:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:53250 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756832Ab2CLWWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:22:34 -0400
Message-ID: <1331590938.18960.57.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Date: Mon, 12 Mar 2012 23:22:18 +0100
In-Reply-To: <20120312221050.GG23255@google.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 15:10 -0700, Tejun Heo wrote:
> 
> * How to map controllers which aren't aware of full hierarchy is still
>   an open question but I'm still standing by one active node on any
>   root-to-leaf path w/ root group serving as the special rest group. 

What does this mean?
