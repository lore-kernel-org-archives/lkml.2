Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab2CSPxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 11:53:19 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36881 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab2CSPxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 11:53:17 -0400
Date: Mon, 19 Mar 2012 15:53:10 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jesse Barnes <jbarnes@virtuousgeek.org>, romain@orebokech.com,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [ 05/38] PCI: ignore pre-1.1 ASPM quirking when ASPM is
 disabled
Message-ID: <20120319155310.GA4441@srcf.ucam.org>
References: <20120316233447.747702375@linuxfoundation.org>
 <4F670872.2090700@suse.cz>
 <20120319154633.GA8176@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319154633.GA8176@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 08:46:33AM -0700, Greg KH wrote:
> On Mon, Mar 19, 2012 at 11:20:34AM +0100, Jiri Slaby wrote:
> > On 03/17/2012 12:34 AM, Greg KH wrote:
> > > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > The commit below is reported to crash the machine in the early init. See
> > the first reply to this message (lkml.org seems to be down right now):
> > lkml.org/lkml/2012/3/18/132
> 
> Yes, but this patch fixes machines that others have been reporting
> problems with, so, what am I supposed to do?
> 
> I'll stick with this patch for now, and hope that Matthew fixes this up
> in Linus's tree and I'll suck that fix in when it gets there.  Is that
> ok?
> 
> Matthew, you are still working on this, right?  :)

Well I only got the report this morning and a quick look didn't tell me 
what was up, but yes, I'm certainly working on this.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
