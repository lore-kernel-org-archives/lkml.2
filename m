Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2CBLxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 06:53:05 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:44402 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755210Ab2CBLxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 06:53:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/iU80QK2riLw/PTkLifcouw+6OyT8AinyN+nxwWw
	fQRoMm2sbz9m10
Message-ID: <1330689175.7414.207.camel@marge.simpson.net>
Subject: Re: [RFD] cgroup: about multiple hierarchies
From: Mike Galbraith <efault@gmx.de>
To: Michal Schmidt <mschmidt@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Tejun Heo <tj@kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>
Date: Fri, 02 Mar 2012 12:52:55 +0100
In-Reply-To: <4F50A63F.40306@redhat.com>
References: <20120221211938.GE12236@google.com>
	 <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	 <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	 <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <20120301210213.GF13533@redhat.com>
	 <1330639448.7414.97.camel@marge.simpson.net> <4F50A63F.40306@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 11:51 +0100, Michal Schmidt wrote: 
> On 03/01/2012 11:04 PM, Mike Galbraith wrote:
> > Hm.  Controllers are perhaps not required, but cpu controller was
> > configured and used without consent.  I didn't receive an offer.
> 
> This is optional.
> 
> "DefaultControllers=" in /etc/systemd/system.conf

#DefaultControllers=cpu is what was there.  But we're OT, and my
annoyance went *poof* when systemd-sysvinit did.

-Mike

