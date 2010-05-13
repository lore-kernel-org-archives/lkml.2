Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab0EMX4O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 19:56:14 -0400
Received: from tango.0pointer.de ([85.214.72.216]:46831 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab0EMX4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 19:56:12 -0400
Date: Fri, 14 May 2010 01:55:42 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100513235542.GA30093@tango.0pointer.de>
References: <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
 <20100513203654.GA14528@tango.0pointer.de>
 <20100513204159.GA15291@tango.0pointer.de>
 <20100513210738.GV3296@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100513210738.GV3296@balbir.in.ibm.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14.05.10 02:37, Balbir Singh (balbir@linux.vnet.ibm.com) wrote:

> > > Oh, that is possible? How would I do that? 
> > > 
> > > This certainly doesn't work:
> > > 
> > > # mount waldo -t cgroup /tmp/xxxx -o defaults
> > 
> > An neither does this:
> > 
> > # mount waldo -t cgroup /tmp/xxxx -o name=systemd
> > 
> > (the mount() syscall fails with EINVAL here, the other one fails with EBUSY)
> >
> 
> Can you try the command below
> 
> mount -t cgroup cgroup -o none,name=hello /cgroup/ 
> 
> Works for me.

That line certainly works, but unfortunately your own libcgroup
completely ignores mount points like this. Meh.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
