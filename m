Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2C2IhM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:37:12 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:44274 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839Ab2C2IhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:37:05 -0400
Message-ID: <1333010107.2823.18.camel@dabdike>
Subject: Re: linux-next: build failure after merge of the scsi tree
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Gerard Snitselaar <dev@snitselaar.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 29 Mar 2012 09:35:07 +0100
In-Reply-To: <20120329192507.64c6c57b65cd0568d5e89ccc@canb.auug.org.au>
References: <20120326121719.dc4c2b1faca5cf12c8d76d93@canb.auug.org.au>
	 <1332748641.2836.8.camel@dabdike> <20120326140721.GA19827@kroah.com>
	 <20120327221721.GA3233@p183.telecom.by> <20120327222216.GB469@kroah.com>
	 <20120327223510.GB3233@p183.telecom.by> <20120328235217.GA17212@kroah.com>
	 <20120329073240.GA21382@perelman.Home>
	 <20120329192507.64c6c57b65cd0568d5e89ccc@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-29 at 19:25 +1100, Stephen Rothwell wrote:
> On Thu, 29 Mar 2012 00:32:40 -0700 Gerard Snitselaar <dev@snitselaar.org> wrote:
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

The plan is to put them back once we go 3.4-rc1 so we have a whole
release cycle to fix up any breakage.

James


