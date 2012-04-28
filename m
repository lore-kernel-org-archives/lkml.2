Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2D1RH6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 13:07:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42883 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752447Ab2D1RH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 13:07:56 -0400
Message-ID: <1335632874.4191.8.camel@joe2Laptop>
Subject: Re: [PATCH EDACv16 1/2] edac: Change internal representation to
 work with layers
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Mark Gross <mark.gross@intel.com>,
        Jason Uhlenkott <juhlenko@akamai.com>,
        Tim Small <tim@buttersideup.com>,
        Ranganathan Desikan <ravi@jetztechnologies.com>,
        "Arvind R." <arvino55@gmail.com>, Olof Johansson <olof@lixom.net>,
        Egor Martovetsky <egor@pasemi.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Michal Marek <mmarek@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Hitoshi Mitake <h.mitake@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Niklas =?ISO-8859-1?Q?S=F6derlund?= 
	<niklas.soderlund@ericsson.com>,
        Shaohui Xie <Shaohui.Xie@freescale.com>,
        Josh Boyer <jwboyer@gmail.com>, linuxppc-dev@lists.ozlabs.org
Date: Sat, 28 Apr 2012 13:07:54 -0400
In-Reply-To: <20120428091621.GE26065@aftab.osrc.amd.com>
References: <1335289087-11337-1-git-send-email-mchehab@redhat.com>
	 <1335291342-14922-1-git-send-email-mchehab@redhat.com>
	 <20120427133304.GE9626@aftab.osrc.amd.com> <4F9ADCE3.2030506@redhat.com>
	 <20120428091621.GE26065@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-04-28 at 11:16 +0200, Borislav Petkov wrote:
> On Fri, Apr 27, 2012 at 02:52:35PM -0300, Mauro Carvalho Chehab wrote:
> > > All those local variables should be sorted in a reverse christmas tree
> > > order:
> > > 
> > > 	u32 this_is_the_longest_array_name[LENGTH];
> > > 	void *shorter_named_variable;
> > > 	unsigned long size;
> > > 	int i;
> > > 
> > > 	...
> > 
> > Why? There's nothing at the CodingStyle saying about how the vars should
> > be ordered. If you want to enforce some particular order, please do it
> > yourself, but apply it consistently among the entire subsystem.
> 
> First of all, this way it is more readable.

Not in my opinion, and blindly using "reverse christmas tree"
can separate variables that should be declared together.


