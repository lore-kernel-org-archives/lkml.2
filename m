Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722Ab0GRQwn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jul 2010 12:52:43 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:52553 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756685Ab0GRQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jul 2010 12:52:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VPBfY7NAw23C8qg6T9z5OeMW3IFJmvBcTSWRiUmMPMWNe316SPi/SI7pec+gvuaEvj
         BYO8FChFBf9TFjhzjq2hIgAV3L1U43otjmLBD7zLVuw7MP/NNP7LDeVHG3S6RVWd0DJA
         SaEy46+1R5yBCbS/3N3q0L4gqkADSqeOMp6bM=
Subject: Re: [PATCH 1/2] Remove REDWOOD_[456] config options and
 conditional code
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Cc: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>,
        Milton Miller <miltonm@bga.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Solomon Peachy <solomon@linux-wlan.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Mike Frysinger <vapier@gentoo.org>, Jiri Kosina <jkosina@suse.cz>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
        Alexander Kurz <linux@kbdbabel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        John Linn <john.linn@xilinx.com>,
        Florian Fainelli <florian@openwrt.org>,
        Nicolas Pitre <nico@fluxnic.net>, Joe Perches <joe@perches.com>,
        Ladislav Michl <ladis@linux-mips.org>,
        David Brown <davidb@quicinc.com>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, vamos-dev@i4.informatik.uni-erlangen.de
In-Reply-To: <20100716142055.GA11736@zod.rchland.ibm.com>
References: <4f07b3092cafbbba37d61d367cc7484e24d18d2a.1279116162.git.qy03fugy@stud.informatik.uni-erlangen.de>
	 <redwood56-reply-1-miltonm@bga.com>
	 <cover.1279282865.git.qy03fugy@stud.informatik.uni-erlangen.de>
	 <ca1bb25d203618c3548748f5efb6f125a96c89e0.1279282865.git.qy03fugy@stud.informatik.uni-erlangen.de>
	 <20100716142055.GA11736@zod.rchland.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 18 Jul 2010 19:52:31 +0300
Message-Id: <1279471951.16247.61.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-16 at 10:20 -0400, Josh Boyer wrote:
> On Fri, Jul 16, 2010 at 02:29:02PM +0200, Christian Dietrich wrote:
> >The config options for REDWOOD_[456] were commented out in the powerpc
> >Kconfig. The ifdefs referencing this options therefore are dead and all
> >references to this can be removed (Also dependencies in other KConfig
> >files).
> >
> >Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> >Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
> 
> This seems fine with me.
> 
> The only question is which tree it coms through.  I'm happy to take it
> in via mine if the netdev and MTD people are fine with that.  Otherwise,
> my ack is below.
> 
> Acked-by: Josh Boyer <jwboyer@linux.vnet.ibm.com>

You know how slow MTD people may be sometimes, so I'd suggest you to
merge this via whatever tree. David is in CC, he'll complain if he is
unhappy, I think.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

