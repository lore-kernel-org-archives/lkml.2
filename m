Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0DKSTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 14:19:09 -0400
Received: from www.tglx.de ([62.245.132.106]:60742 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456Ab0DKSTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 14:19:07 -0400
Date: Sun, 11 Apr 2010 20:16:09 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: Ben Gamari <bgamari.foss@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, tytso@mit.edu, npiggin@suse.de,
       Ingo Molnar <mingo@elte.hu>, Ruald Andreae <ruald.a@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Olly Betts <olly@survex.com>,
       martin f krafft <madduck@madduck.net>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
In-Reply-To: <4BC1E4A4.1070103@redhat.com>
Message-ID: <alpine.LFD.2.00.1004112014520.18009@localhost.localdomain>
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com> <4baeaee5.c5c2f10a.7187.2688@mx.google.com> <20100327204233.0d84542a@infradead.org> <4baf624c.48c3f10a.16d0.ffffccb8@mx.google.com> <87y6hcyu85.fsf@basil.nowhere.org> <4bbf401e.a3b9e70a.13f3.4460@mx.google.com>
 <4BC1E4A4.1070103@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010, Avi Kivity wrote:

> On 04/09/2010 05:56 PM, Ben Gamari wrote:
> > On Mon, 29 Mar 2010 00:08:58 +0200, Andi Kleen<andi@firstfloor.org>  wrote:
> >    
> > > Ben Gamari<bgamari.foss@gmail.com>  writes:
> > > ext4/XFS/JFS/btrfs should be better in this regard
> > > 
> > >      
> > I am using btrfs, so yes, I was expecting things to be better.
> > Unfortunately,
> > the improvement seems to be non-existent under high IO/fsync load.
> > 
> >    
> 
> btrfs is known to perform poorly under fsync.

XFS does not do much better. Just moved my VM images back to ext for
that reason.

Thanks,

	tglx
