Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2C2JEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 05:04:10 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39938 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2C2JEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 05:04:02 -0400
Date: Thu, 29 Mar 2012 02:03:51 -0700
From: Gerard Snitselaar <dev@snitselaar.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the scsi tree
Message-ID: <20120329090332.GA21472@perelman.Home>
Reply-To: Gerard Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <gregkh@linuxfoundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
 <1332748641.2836.8.camel@dabdike>
 <20120326140721.GA19827@kroah.com>
 <20120327221721.GA3233@p183.telecom.by>
 <20120327222216.GB469@kroah.com>
 <20120327223510.GB3233@p183.telecom.by>
 <20120328235217.GA17212@kroah.com>
 <20120329073240.GA21382@perelman.Home>
 <20120329192507.64c6c57b65cd0568d5e89ccc@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329192507.64c6c57b65cd0568d5e89ccc@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Mar 29 12, Stephen Rothwell wrote:
> On Thu, 29 Mar 2012 00:32:40 -0700 Gerard Snitselaar <dev@snitselaar.org> wrote:
> >
> > On Wed Mar 28 12, Greg KH wrote:
> > > > > > 
> > > > > > See commits 422f07001d6638fdde28f1909cc9162bc7f571d3..104c4fe25dc9bde823ba4591e910a77071b98ab5
> > > > > > Especially the first one.
> > > 
> > > I don't know where to find these patches, care to send them to me, or
> > > point me at a link with them?
> > > 
> > 
> > They are visible in next-20120329
> 
> I don't think so.  They were in next-2012032[67], but were removed again.
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

Sorry, poorly worded on my part. What I meant to say was I could see
the commits in the repository when doing
 
git show 422f07001d6638fdde28f1909cc9162bc7f571d3..104c4fe25dc9bde823ba4591e910a77071b98ab5
