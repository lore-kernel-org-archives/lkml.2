Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485Ab0EMUh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:37:27 -0400
Received: from tango.0pointer.de ([85.214.72.216]:58274 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756577Ab0EMUh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:37:26 -0400
Date: Thu, 13 May 2010 22:36:54 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Paul Menage <menage@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100513203654.GA14528@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it>
 <eJktY-7JG-7@gated-at.bofh.it>
 <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s2s6599ad831005131306pa7db4c4dyd7712de7fda73cfd@mail.gmail.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13.05.10 13:06, Paul Menage (menage@google.com) wrote:

> 
> On Thu, May 13, 2010 at 7:03 AM, Lennart Poettering
> <mzxreary@0pointer.de> wrote:
> > By default systemd will create its groups in the "debug" hierarchy, (at
> > least for now, in the long run i'd like to see "noop" hierarchy or so,
> > that doesn't sound so temporary), since that controller is not useful
> 
> If you just want to track processes, mount a (named) hierarchy with no
> attached subsystems.

Oh, that is possible? How would I do that? 

This certainly doesn't work:

# mount waldo -t cgroup /tmp/xxxx -o defaults

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
