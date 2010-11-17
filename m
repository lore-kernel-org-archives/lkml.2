Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935595Ab0KQWiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:38:04 -0500
Received: from canuck.infradead.org ([134.117.69.58]:51606 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935070Ab0KQWiC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:38:02 -0500
Subject: Re: [RFC/RFT PATCH v3] sched: automated per tty task groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Dhaval Giani <dhaval.giani@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Vivek Goyal <vgoyal@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20101117223411.GA23983@tango.0pointer.de>
References: <1289916171.5169.117.camel@maggy.simson.net>
	 <1289916683.2109.625.camel@laptop>
	 <AANLkTimun-VUNx77wJ4w7Z4io2jder=xkN5pCujPQL-a@mail.gmail.com>
	 <20101116170312.GA19327@tango.0pointer.de>
	 <AANLkTi=CNEdUF_J4Mnyt9X52PvP2ftvrgsWVsRv1JW9M@mail.gmail.com>
	 <20101116181603.GC19327@tango.0pointer.de>
	 <AANLkTik7hxds1--gSWEtHGAfU607S=mZpvBrBdpFmCD=@mail.gmail.com>
	 <20101116202839.GC27235@tango.0pointer.de>
	 <20101116205243.64e4a67a@lxorguk.ukuu.org.uk>
	 <AANLkTinSXM5RMH+1FHtkYJiehcyZaxZGs0z4ycLGGE9u@mail.gmail.com>
	 <20101117223411.GA23983@tango.0pointer.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Nov 2010 23:37:15 +0100
Message-ID: <1290033435.2109.1282.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 23:34 +0100, Lennart Poettering wrote:
> 
> This should fix things for people with systemd and GNOME. Yes, all
> others are left in the cold. Sorry for that. 

Is there an easy opt out for that, other than booting a CONFIG_CGROUP=n
kernel?
