Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab1C2DSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:18:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:57527 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab1C2DSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:18:38 -0400
Date: Mon, 28 Mar 2011 20:17:25 -0700
From: Greg KH <gregkh@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
        Rick Koshi <nfs-bug-report@more-right-rudder.com>,
        Ivo =?utf-8?Q?P=C5=99ikryl?= <prikryl@eurosat.cz>
Subject: Re: 2.6.38.2: regression from 2.6.38: kernel BUG at
 fs/nfsd/nfs4state.c:380!
Message-ID: <20110329031725.GA3665@suse.de>
References: <201103282223.06191.wolfgang.walter@stwm.de>
 <20110328203207.GA17493@suse.de>
 <201103282300.57903.wolfgang.walter@stwm.de>
 <20110328214122.GA19854@suse.de>
 <20110329031347.GC2695@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329031347.GC2695@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:13:47PM -0400, J. Bruce Fields wrote:
> Bah, apologies about this, I don't know how it got through my own
> testing.
> 
> On Mon, Mar 28, 2011 at 02:41:22PM -0700, Greg KH wrote:
> > On Mon, Mar 28, 2011 at 11:00:57PM +0200, Wolfgang Walter wrote:
> > > I just searched linux-nfs and found this:
> > > 
> > > http://marc.info/?l=linux-nfs&m=130129644016061&w=4
> > > 
> > > He even seems to have a real fix though I don't want to test it
> > > without blessing.
> > 
> > Well, you aren't going to get that from me, Bruce?
> 
> Good analysis from Mi Jinlong, but I'm not convinced by the patch....
> 
> I'll look closer.
> 
> (Disclaimer: between the sleep deprivation and the UM hospital's dubious
> guest wifi (hey, how's a new dad supposed to keep up with his kernel
> hacking if they block git?), I may be a little slow.)

Hey, no rush, you have more important things to deal with, I can always
revert the patch for now :)

thanks,

greg k-h
