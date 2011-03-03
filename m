Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab1CCAKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 19:10:34 -0500
Received: from tomasu.net ([64.85.170.234]:53485 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1CCAKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 19:10:33 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: File/memory corruption in 2.6.37?
Date: Wed, 2 Mar 2011 17:10:28 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.37.2; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <201102251457.51476.thomas@fjellstrom.ca> <201102251531.00363.thomas@fjellstrom.ca> <20110302155226.05fbe993.akpm@linux-foundation.org>
In-Reply-To: <20110302155226.05fbe993.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103021710.29016.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On March 2, 2011, Andrew Morton wrote:
> On Fri, 25 Feb 2011 15:31:00 -0700
> 
> Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> > On February 25, 2011, Thomas Gleixner wrote:
> > > On Fri, 25 Feb 2011, Thomas Fjellstrom wrote:
> > > > On February 25, 2011, you wrote:
> > > > > Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder
> > > > > indexes are being corrupted fairly regularly. Far more often than
> > > > > is usual (almost never). Several a day in fact are being
> > > > > corrupted. I can only imagine that this isn't the only corruption
> > > > > happening and it is worrying.
> > > > 
> > > > Forgot to give any kind of useful info:
> > > > 
> > > > System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45
> > > > intel gfx
> > > > 
> > > > running debian sid, with the current debian 2.6.37 kernel, was
> > > > running a hand rolled 2.6.36 kernel with autogroup applied and
> > > > didn't have these issues.
> > > 
> > > Could you verify that with an hand rolled 2.6.37.2 ?
> > > 
> > > Thanks,
> > > 
> > > 	tglx
> > 
> > I suppose it won't hurt to give it a try.
> 
> Any results yet?
> 
> Which filesystem is being used?  I've seen at least one similar report
> for reiserfs.

So far I haven't noticed the corruption with 2.6.37.2, and I'm using ext3. I'm 
going to test with the debian kernel again soon here to see if the problem 
come back. I was just seeing if maybe it only happens when I've been using the 
system for a long time. I tend to have a lot of issues with this laptop once 
its been running for a long enough period (typically related to the intel_gfx 
drivers leaking and causing crashes or general unstableness). I had to restart 
my laptop a couple days ago, due to it not noticing the resume image.. but I 
didn't notice any corruption before that.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
