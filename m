Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2EBW11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 18:27:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:60801 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab2EBW11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 18:27:27 -0400
Date: Wed, 2 May 2012 23:27:24 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [now bisected] Weird bluetooth keyboard regression - just me?
Message-ID: <20120502222724.GB2215@srcf.ucam.org>
References: <20120501110156.2b6e0561@lwn.net>
 <20120501171901.GA26006@srcf.ucam.org>
 <20120501120145.21f65ae2@lwn.net>
 <20120501183149.GA28536@srcf.ucam.org>
 <20120501123923.01ac1138@lwn.net>
 <20120501185455.GA29060@srcf.ucam.org>
 <20120501192736.GA29770@srcf.ucam.org>
 <20120501172454.0e811379@lwn.net>
 <20120502215034.GA622@srcf.ucam.org>
 <20120502160437.5f355fa3@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120502160437.5f355fa3@lwn.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 04:04:37PM -0600, Jonathan Corbet wrote:
> On Wed, 2 May 2012 22:50:34 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > > > In either case, does the 
> > > > attached file help if dropped into /lib/udev/rules.d ?  
> > > 
> > > Nope, no joy there.    
> > 
> > You tested after rebooting?
> 
> Yes, of course.  I'm running a kernel that actually talks to my keyboard
> most of the time, I *have* to reboot to try a broken one.

Hm. Well, easiest thing to do would just to be to delete that for the 
moment and make sure that things work again - beyond that it's me trying 
to figure out how to write a udev file to do the right thing when I 
don't have hardware that has this layout. I'll see if I can mock it up.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
