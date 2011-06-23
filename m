Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab1FWM43 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 08:56:29 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:56006 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759043Ab1FWM42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 08:56:28 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 23 Jun 2011 14:56:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: 3.0-rc3: new sparse noise on module_param_named: "error: Syntax
 error in unary expression"
Message-ID: <20110623145615.2ff3cd77@stein>
In-Reply-To: <20110622210504.0ceb268d.rdunlap@xenotime.net>
References: <20110621163040.717fd5ed@stein>
	<20110622210504.0ceb268d.rdunlap@xenotime.net>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 22 Randy Dunlap wrote:
> On Tue, 21 Jun 2011 16:30:40 +0200 Stefan Richter wrote:
> > make C=1 in 3.0-rc3 but not in 2.6.39 complains:
> > 
> >   CHECK   drivers/firewire/ohci.c
> > drivers/firewire/ohci.c:308:1: error: Syntax error in unary expression
> > drivers/firewire/ohci.c:325:1: error: Syntax error in unary expression
[...]
> Please see if http://marc.info/?l=linux-kernel&m=130677145629121&w=2
> fixes the breakage.

Apparently it does.  I didn't check this particular patch, but these
errors do not appear anymore in 3.0-rc4 which has got this patch.
Thanks.
-- 
Stefan Richter
-=====-==-== -==- =-===
http://arcgraph.de/sr/
