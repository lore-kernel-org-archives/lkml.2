Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758304Ab0FIUyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 16:54:09 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44358 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756573Ab0FIUx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 16:53:56 -0400
Date: Wed, 9 Jun 2010 21:53:50 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ortwin =?iso-8859-1?Q?Gl=FCck?= <odi@odi.ch>, linux-kernel@vger.kernel.org
Subject: Re: freeze when strace X
Message-ID: <20100609205350.GA28383@srcf.ucam.org>
References: <4C0FDF9F.9070000@odi.ch> <20100609195228.GA27088@srcf.ucam.org> <4C0FF34D.6090800@odi.ch> <20100609200610.GA27536@srcf.ucam.org> <alpine.LFD.2.00.1006092232180.2933@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006092232180.2933@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 10:47:23PM +0200, Thomas Gleixner wrote:
> On Wed, 9 Jun 2010, Matthew Garrett wrote:
> > strace needs to output text via X, which generates output which needs to 
> > be output via X... and you'll tend to deadlock. If X is holding any 
> > interesting kernel locks at that point then it wouldn't surprise me if 
> > the machine ends up dead.
> 
> Nothing to do with kernel locks. strace hooks into the syscall and
> intercepts the data, so X is stopped at that point. Now try to send
> output to a program which you stopped yourself :)

Oh, yeah, and ctrl+alt+fwhatever is handled by X.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
