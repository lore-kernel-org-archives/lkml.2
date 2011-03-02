Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab1CBXxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 18:53:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52200 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845Ab1CBXxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 18:53:13 -0500
Date: Wed, 2 Mar 2011 15:52:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: thomas@fjellstrom.ca
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: File/memory corruption in 2.6.37?
Message-Id: <20110302155226.05fbe993.akpm@linux-foundation.org>
In-Reply-To: <201102251531.00363.thomas@fjellstrom.ca>
References: <201102251457.51476.thomas@fjellstrom.ca>
	<201102251508.45122.thomas@fjellstrom.ca>
	<alpine.LFD.2.00.1102252323120.2701@localhost6.localdomain6>
	<201102251531.00363.thomas@fjellstrom.ca>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Feb 2011 15:31:00 -0700
Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:

> On February 25, 2011, Thomas Gleixner wrote:
> > On Fri, 25 Feb 2011, Thomas Fjellstrom wrote:
> > > On February 25, 2011, you wrote:
> > > > Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder
> > > > indexes are being corrupted fairly regularly. Far more often than is
> > > > usual (almost never). Several a day in fact are being corrupted. I can
> > > > only imagine that this isn't the only corruption happening and it is
> > > > worrying.
> > > 
> > > Forgot to give any kind of useful info:
> > > 
> > > System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45 intel
> > > gfx
> > > 
> > > running debian sid, with the current debian 2.6.37 kernel, was running a
> > > hand rolled 2.6.36 kernel with autogroup applied and didn't have these
> > > issues.
> > 
> > Could you verify that with an hand rolled 2.6.37.2 ?
> > 
> > Thanks,
> > 
> > 	tglx
> 
> I suppose it won't hurt to give it a try.
> 

Any results yet?

Which filesystem is being used?  I've seen at least one similar report
for reiserfs.

