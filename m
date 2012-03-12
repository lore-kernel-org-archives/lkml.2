Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757982Ab2CLXDF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:03:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:54264 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab2CLXDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:03:02 -0400
Message-ID: <1331593367.18960.66.camel@twins>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Date: Tue, 13 Mar 2012 00:02:47 +0100
In-Reply-To: <20120312230020.GL23255@google.com>
References: <20120221211938.GE12236@google.com>
	 <20120312221050.GG23255@google.com> <1331590938.18960.57.camel@twins>
	 <20120312222817.GI23255@google.com>
	 <20120312223113.GB18359@tango.0pointer.de>
	 <20120312230020.GL23255@google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-12 at 16:00 -0700, Tejun Heo wrote:
> 
> Ooh, both will be available to choose from.  I was trying to explain
> that there can be configuration only at one layer for any task so that
> it can be mapped to flat hierarchy.  Where to apply the config will be
> selected by the user (or system tool). 

Thus in effect this is a false choice, since Lennart and assorted idiots
conspire against sanity by pushing systemd into our every orifice, and
since he just said systemd requires one of the two, the choice will be
made for us, lest we forfeit wanting to boot our system.
