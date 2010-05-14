Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab0ENGyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 02:54:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:44821 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab0ENGyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 02:54:14 -0400
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
From: Peter Zijlstra <peterz@infradead.org>
To: balbir@linux.vnet.ibm.com
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
In-Reply-To: <20100514054336.GX3296@balbir.in.ibm.com>
References: <eJktY-7JG-7@gated-at.bofh.it> <eJktY-7JG-5@gated-at.bofh.it>
	 <4BEAB6FC.8090105@intcomgrp.com>
	 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
	 <1273674048.1626.117.camel@laptop> <20100512190757.GA421@tango.0pointer.de>
	 <1273755719.5605.3537.camel@twins>
	 <20100513140354.GA12639@tango.0pointer.de>
	 <1273785546.5605.3556.camel@twins>
	 <20100514000252.GB30093@tango.0pointer.de>
	 <20100514054336.GX3296@balbir.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 14 May 2010 08:53:48 +0200
Message-ID: <1273820028.5605.3565.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 11:13 +0530, Balbir Singh wrote:

> I think the config options are the domains of the distributors 

Whoever runs a distro kernel anyway? This is LKML, we're kernel devs.

> I am not sure why CONFIG_CGROUP=y is so bad, Peter, could you
> elaborate? 

Because it adds code I don't use and adds to the compile overhead.
