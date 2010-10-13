Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab0JMJNy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 05:13:54 -0400
Received: from smtp5.freeserve.com ([193.252.22.151]:3435 "EHLO
	smtp6.freeserve.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753357Ab0JMJNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 05:13:53 -0400
X-ME-UUID: 20101013091349363.58B331C00090@mwinf3541.me.freeserve.com
Date: Wed, 13 Oct 2010 10:13:35 +0100
From: Chris Vine <chris@cvine.freeserve.co.uk>
To: sam <sam.tygier@hep.manchester.ac.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Lenovo S12 2.6.36-rc7 lockup
Message-ID: <20101013101335.4714d70d@boulder.homenet>
In-Reply-To: <1286922146.4040.2.camel@oberon>
References: <20101010135912.76eb61b7@boulder.homenet>
	<20101010164818.6617102c@boulder.homenet>
	<1286922146.4040.2.camel@oberon>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010 23:22:26 +0100
sam <sam.tygier@hep.manchester.ac.uk> wrote:
> i have seen similar issue while running with older kernels (2.6.32)
> on a S12 (intel GPU version). there is an ubuntu bug
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/643822
> 
> the "nolapic_timer" boot flag fixes it for me.

Interesting, yes, the 'nolapic_timer' option fixes it on this netbook,
but that seems a bit sub-optimal as it will presumably force use of i/o
apic. Whether that makes much difference in practice I don't know: the
netbook has a single Atom processor which does hyperthreading to appear
as two.

kernel 2.6.36-rc is the first kernel to trigger this on this particular
netbook.

Chris


