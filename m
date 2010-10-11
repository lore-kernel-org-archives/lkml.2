Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907Ab0JKWdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:33:47 -0400
Received: from www.tglx.de ([62.245.132.106]:51721 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756672Ab0JKWdq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:33:46 -0400
Date: Tue, 12 Oct 2010 00:33:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Tim Pepper <lnxninja@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Marcio Saito <marcio@cyclades.com>,
        Jiri Slaby <jirislaby@gmail.com>, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, John Stultz <johnstul@us.ibm.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: Re: [RFC] [PATCH] allow low HZ values?
In-Reply-To: <1286836212.5220.19.camel@pasglop>
Message-ID: <alpine.LFD.2.00.1010120032060.2909@localhost6.localdomain6>
References: <20101011201121.GA953@tpepper-t61p.dolavim.us> <1286836212.5220.19.camel@pasglop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Benjamin Herrenschmidt wrote:

> On Mon, 2010-10-11 at 13:11 -0700, Tim Pepper wrote:
> > I'm not necessarily wanting to open up the age old question of "what is
> > a good HZ", but we were doing some testing on timer tick overheads for
> > HPC applications and this came up...
> 
> Note that this is also very useful when working on CPU prototypes
> implemented in FPGAs and running at something like 12Mhz :-)

/me hands benh 0.5$ for a FPGA upgrade
