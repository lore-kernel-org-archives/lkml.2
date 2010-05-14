Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab0ENKjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 06:39:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:47137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab0ENKi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 06:38:59 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
In-Reply-To: <20100514081248.GE3296@balbir.in.ibm.com>
References: <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop> <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <1273785546.5605.3556.camel@twins>
	 <20100514000252.GB30093@tango.0pointer.de>
	 <20100514054336.GX3296@balbir.in.ibm.com>
	 <1273820028.5605.3565.camel@twins>
	 <20100514081248.GE3296@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 12:38:55 +0200
Message-ID: <1273833535.1626.242.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 13:42 +0530, Balbir Singh wrote:

> Heh! agreed, but we are a small population and moreover a large
> population would benefit from systemd and parallel boot.

CONFIG_CGROUP=y isn't a requirement for parallel boot. People have been
doing that for years without it.

And I'm not against systemd using cgroups per-se, I'm against it
mandating it. It could simply not use them and not provide whatever it
needs them for when not present.

CONFIG_CGROUP is an option, so people can say no. 

Same for CONFIG_SYSFS, udev gets highly unhappy when disabled, but init
still works and you do get a shell of some sort. If you pre-populate
your /dev with static device nodes you can actually make it all the way
to runlevel 3 the last time I tried.



