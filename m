Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab1BYWbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 17:31:37 -0500
Received: from tomasu.net ([64.85.170.234]:53971 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932436Ab1BYWbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 17:31:36 -0500
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: File/memory corruption in 2.6.37?
Date: Fri, 25 Feb 2011 15:31:00 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.37-1-amd64; KDE/4.5.2; x86_64; svn-1188918; 2010-10-21)
Cc: linux-kernel@vger.kernel.org
References: <201102251457.51476.thomas@fjellstrom.ca> <201102251508.45122.thomas@fjellstrom.ca> <alpine.LFD.2.00.1102252323120.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102252323120.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102251531.00363.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On February 25, 2011, Thomas Gleixner wrote:
> On Fri, 25 Feb 2011, Thomas Fjellstrom wrote:
> > On February 25, 2011, you wrote:
> > > Ever since I upgraded to 2.6.37 from 2.6.36, that kmail's folder
> > > indexes are being corrupted fairly regularly. Far more often than is
> > > usual (almost never). Several a day in fact are being corrupted. I can
> > > only imagine that this isn't the only corruption happening and it is
> > > worrying.
> > 
> > Forgot to give any kind of useful info:
> > 
> > System: Lenovo SL500 laptop, intel core2duo T9400 cpu, 4G ram, gm45 intel
> > gfx
> > 
> > running debian sid, with the current debian 2.6.37 kernel, was running a
> > hand rolled 2.6.36 kernel with autogroup applied and didn't have these
> > issues.
> 
> Could you verify that with an hand rolled 2.6.37.2 ?
> 
> Thanks,
> 
> 	tglx

I suppose it won't hurt to give it a try.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
