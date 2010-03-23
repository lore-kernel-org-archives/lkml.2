Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0CWMMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:12:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0CWMMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:12:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Matt Mackall <mpm@selenic.com>
Cc: Amerigo Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
       Andy Gospodarek <gospo@redhat.com>, Neil Horman <nhorman@tuxdriver.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       bonding-devel@lists.sourceforge.net, Jay Vosburgh <fubar@us.ibm.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [RFC Patch 1/3] netpoll: add generic support for bridge and bonding devices
References: <20100322082059.4967.63492.sendpatchset@localhost.localdomain>
	<1269297081.3552.19.camel@calx>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 23 Mar 2010 08:11:13 -0400
In-Reply-To: <1269297081.3552.19.camel@calx> (Matt Mackall's message of "Mon,
	22 Mar 2010 17:31:21 -0500")
Message-ID: <x49zl1zxmou.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall <mpm@selenic.com> writes:

> On Mon, 2010-03-22 at 04:17 -0400, Amerigo Wang wrote:
>> This whole patchset is for adding netpoll support to bridge and bonding
>> devices. I already tested it for bridge, bonding, bridge over bonding,
>> and bonding over bridge. It looks fine now.
>
> Ages ago, Jeff Moyer took a run at this, added him to the cc: on the off
> chance he still cares.

I'll take a look at it in a bit.  For now, here is the link to my
original post on this for Amerigo's reading pleasure:

  http://lkml.indiana.edu/hypermail/linux/kernel/0507.0/0206.html

Cheers,
Jeff
