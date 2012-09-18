Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459Ab2IRCaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 22:30:18 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:60859 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932106Ab2IRCaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 22:30:15 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+wxnQfvpVUHwE2EqBAw8No
Date: Mon, 17 Sep 2012 19:30:12 -0700
From: Tony Lindgren <tony@atomide.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, Fengguang Wu <fengguang.wu@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH] mfd: Fix compile for twl-core.c by removing
 cpu_is_omap usage
Message-ID: <20120918023011.GO11762@atomide.com>
References: <20120917202943.GV4521@atomide.com>
 <alpine.DEB.2.00.1209172207480.16117@utopia.booyaka.com>
 <20120917221406.GG11762@atomide.com>
 <alpine.DEB.2.00.1209172222570.18885@utopia.booyaka.com>
 <20120917222635.GI11762@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120917222635.GI11762@atomide.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Tony Lindgren <tony@atomide.com> [120917 15:27]:
> * Paul Walmsley <paul@pwsan.com> [120917 15:25]:
> > On Mon, 17 Sep 2012, Tony Lindgren wrote:
> > 
> > > We need to queue this ASAP and before other patches to fix the
> > > build breakage in linux next. Then you can merge in that commit
> > > too, does that work for you?
> > 
> > That's fine, we'll just need a stable commit then that the CCF patches can 
> > be based on.
> 
> OK cool, will let you know that once we hear from Samuel. Care to
> ack the clock related changes?
> 
> There's pm24xx.c at least using osc_ck naming, so I added a new
> alias to keep it generic for the driver instead of using omap
> specific names.

Pushed out now with the ack from Samuel and sent the pull request.

Regards,

Tony
