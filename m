Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab2EINNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:13:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759275Ab2EINNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:13:22 -0400
Date: Wed, 9 May 2012 12:44:46 +0200
From: Jan Kara <jack@suse.cz>
To: =?iso-8859-1?Q?Llu=EDs?= Batlle i Rossell <viric@viric.name>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: BUG on fs/inode.c:1442 (linux 3.3.1 and 3.3.2)
Message-ID: <20120509104446.GB5092@quack.suse.cz>
References: <20120415215601.GV1927@vicerveza.homeunix.net>
 <20120418114844.GA22295@quack.suse.cz>
 <20120506123100.GI1927@vicerveza.homeunix.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120506123100.GI1927@vicerveza.homeunix.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 06-05-12 14:31:00, Lluís Batlle i Rossell wrote:
> On Wed, Apr 18, 2012 at 01:48:44PM +0200, Jan Kara wrote:
> >   Hello,
> > 
> > On Sun 15-04-12 23:56:01, Lluís Batlle i Rossell wrote:
> > > destroying my openvpn client connection (SIGINT to openvp), in linux 3.3.1 and
> > > now also in 3.3.2, I noticed this BUG in dmesg (attached).
> > > 
> > > It's a vanilla 3.3.2, at this shot.
> > > 
> > > I know it never happened to me in any 3.2, but I did not try 3.3.0.
> > > 
> > > I attach the .config. And I have the debug info for this kernel too, if this
> > > helps someone find a fix. But I imagine it's easy to reproduce.
> >   From the first look it would seem as use after free bug but can you
> > please post disassembly of iput() function from your kernel? I.e. you load
> > vmlinux in gdb and run 'disass iput'. Thanks.
> 
> Sorry for the delay. Here it is, for 3.3.2:
  Thanks for the disassembly. I was hoping that the contents of
inode->i_state would be loaded in some register so we can see what value
it has. Sadly that's not the case so I cannot say anything more.

Did the bug happen to you again after the original report?

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
