Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2CEMnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:43:16 -0500
Received: from tango.0pointer.de ([85.214.72.216]:37543 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2CEMnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:43:14 -0500
Date: Mon, 5 Mar 2012 13:43:10 +0100
From: Lennart Poettering <mzxreary@0pointer.de>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>, Michal Schmidt <mschmidt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Message-ID: <20120305124310.GD10929@tango.0pointer.de>
References: <20120221211938.GE12236@google.com>
 <20120222163858.GB4128@redhat.com>
 <20120222165714.GC4128@redhat.com>
 <1329990094.24994.64.camel@twins>
 <1330006399.11248.20.camel@twins>
 <4F4FAF89.3090706@redhat.com>
 <1330633603.7414.49.camel@marge.simpson.net>
 <20120301210213.GF13533@redhat.com>
 <1330639448.7414.97.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330639448.7414.97.camel@marge.simpson.net>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01.03.12 23:04, Mike Galbraith (efault@gmx.de) wrote:

> 
> On Thu, 2012-03-01 at 16:02 -0500, Vivek Goyal wrote: 
> > On Thu, Mar 01, 2012 at 09:26:43PM +0100, Mike Galbraith wrote:
> 
> > > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> > > over sysvinits job afaiui, what does that have to do with cgroups?
> > 
> > I think they were using it to track all the children forked by a service
> > and cleanup all of them if need be. So they just need it for logical
> > grouping functionality and don't require any controllers as such.
> 
> Hm.  Controllers are perhaps not required, but cpu controller was
> configured and used without consent.  I didn't receive an offer.

Just set DefaultControllers= in /etc/systemd/system.conf to an empty
string and systemd will not make use of any hierarchy beyond its private
name=systemd named hierarchy.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
