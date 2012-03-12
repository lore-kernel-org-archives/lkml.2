Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab2CLTqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:46:07 -0400
Received: from 1wt.eu ([62.212.114.60]:63216 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756440Ab2CLTqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:46:05 -0400
Date: Mon, 12 Mar 2012 20:45:45 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
Message-ID: <20120312194545.GJ12405@1wt.eu>
References: <20120312002046.041448832@1wt.eu> <201203121702.06598.arnd@arndb.de> <20120312193455.GZ12704@decadent.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312193455.GZ12704@decadent.org.uk>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 07:34:55PM +0000, Ben Hutchings wrote:
> On Mon, Mar 12, 2012 at 05:02:06PM +0000, Arnd Bergmann wrote:
> > On Monday 12 March 2012, Willy Tarreau wrote:
> > > 
> > > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > > 
> > > ------------------
> > > 
> > > From: Ben Hutchings <ben@decadent.org.uk>
> > > 
> > > commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream
> > > 
> > > This just changes Kconfig rather than touching all the other files the
> > > original commit did.
> > > 
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > 
> > I think it would be useful to copy the entire description of the
> > original patch here, which makes it clear why it's a good idea
> > to apply this patch to 2.6.32-longterm.
>  
> Agreed.  Willy, will you do this or should I send a new patch?

I'll do it, don't worry. I'm adding this by hand to the patch :

Original patch description :
--
    [IA64] Remove COMPAT_IA32 support
    
    This has been broken since May 2008 when Al Viro killed altroot support.
    Since nobody has complained, it would appear that there are no users of
    this code (A plausible theory since the main OSVs that support ia64 prefer
    to use the IA32-EL software emulation).
    
    Signed-off-by: Tony Luck <tony.luck@intel.com>
--

Thanks Ben,
Willy

