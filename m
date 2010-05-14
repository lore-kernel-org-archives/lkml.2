Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab0ENQHg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 12:07:36 -0400
Received: from tango.0pointer.de ([85.214.72.216]:43269 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab0ENQHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 12:07:34 -0400
Date: Fri, 14 May 2010 18:07:04 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval.giani@gmail.com>,
       James Kosin <jkosin@intcomgrp.com>, linux-kernel@vger.kernel.org,
       menage@google.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100514160704.GA26596@tango.0pointer.de>
References: <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
 <20100512190757.GA421@tango.0pointer.de>
 <1273755719.5605.3537.camel@twins>
 <20100513140354.GA12639@tango.0pointer.de>
 <1273785546.5605.3556.camel@twins>
 <20100514000252.GB30093@tango.0pointer.de>
 <20100514054336.GX3296@balbir.in.ibm.com>
 <1273820028.5605.3565.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273820028.5605.3565.camel@twins>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14.05.10 08:53, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Fri, 2010-05-14 at 11:13 +0530, Balbir Singh wrote:
> 
> > I think the config options are the domains of the distributors 
> 
> Whoever runs a distro kernel anyway? This is LKML, we're kernel devs.

Well, sorry to bring that to you, but I didn't really design systemd as
a development tool for lkml developers. Instead I designed it as a
general purposes system manager.

Lennart

-- 
Lennart Poettering                        Red Hat, Inc.
lennart [at] poettering [dot] net
http://0pointer.net/lennart/           GnuPG 0x1A015CC4
