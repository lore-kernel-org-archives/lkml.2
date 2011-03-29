Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab1C2DNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:13:54 -0400
Received: from fieldses.org ([174.143.236.118]:55114 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab1C2DNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:13:52 -0400
Date: Mon, 28 Mar 2011 23:13:47 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Greg KH <gregkh@suse.de>
Cc: Wolfgang Walter <wolfgang.walter@stwm.de>, linux-kernel@vger.kernel.org,
        Rick Koshi <nfs-bug-report@more-right-rudder.com>,
        Ivo =?utf-8?Q?P=C5=99ikryl?= <prikryl@eurosat.cz>
Subject: Re: 2.6.38.2: regression from 2.6.38: kernel BUG at
 fs/nfsd/nfs4state.c:380!
Message-ID: <20110329031347.GC2695@fieldses.org>
References: <201103282223.06191.wolfgang.walter@stwm.de>
 <20110328203207.GA17493@suse.de>
 <201103282300.57903.wolfgang.walter@stwm.de>
 <20110328214122.GA19854@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328214122.GA19854@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, apologies about this, I don't know how it got through my own
testing.

On Mon, Mar 28, 2011 at 02:41:22PM -0700, Greg KH wrote:
> On Mon, Mar 28, 2011 at 11:00:57PM +0200, Wolfgang Walter wrote:
> > I just searched linux-nfs and found this:
> > 
> > http://marc.info/?l=linux-nfs&m=130129644016061&w=4
> > 
> > He even seems to have a real fix though I don't want to test it
> > without blessing.
> 
> Well, you aren't going to get that from me, Bruce?

Good analysis from Mi Jinlong, but I'm not convinced by the patch....

I'll look closer.

(Disclaimer: between the sleep deprivation and the UM hospital's dubious
guest wifi (hey, how's a new dad supposed to keep up with his kernel
hacking if they block git?), I may be a little slow.)

--b.
