Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965069Ab2CLXnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 19:43:24 -0400
Received: from tango.0pointer.de ([85.214.72.216]:49635 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964904Ab2CLXnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 19:43:21 -0400
Date: Tue, 13 Mar 2012 00:43:19 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120312234319.GA23392@tango.0pointer.de>
References: <20120221211938.GE12236@google.com>
 <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins>
 <20120312222817.GI23255@google.com>
 <20120312223113.GB18359@tango.0pointer.de>
 <20120312230020.GL23255@google.com>
 <1331593367.18960.66.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331593367.18960.66.camel@twins>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13.03.12 00:02, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Mon, 2012-03-12 at 16:00 -0700, Tejun Heo wrote:
> > 
> > Ooh, both will be available to choose from.  I was trying to explain
> > that there can be configuration only at one layer for any task so that
> > it can be mapped to flat hierarchy.  Where to apply the config will be
> > selected by the user (or system tool). 
> 
> Thus in effect this is a false choice, since Lennart and assorted idiots
> conspire against sanity by pushing systemd into our every orifice, and
> since he just said systemd requires one of the two, the choice will be
> made for us, lest we forfeit wanting to boot our system.

I didn't say that that we require one of the two. I just pointed out
that for us the first option makes more sense. Also, as I pointed out I
am happy to adapt systemd to whatever Tejun decides.

BTW, I actually believe the hierachial design of cgroups is pretty neat,
since it allows us to label things hierarchially, so that for example
user services can have their own labels all beneath a per-user label. So
for the purpose of grouping things and naming them I very much
appreciate hierarchial cgroups. For the purpose of actually applying
resource controls I care much less for it, but I still do see its
use.

Lennart

PS: Awesome choice of words! I totally appreciate how you talk to and
about me. This creates such a strong urge inside of me to care about the
problems you have with systemd and fix them for you.

-- 
Lennart Poettering - Red Hat, Inc.
