Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0HBUON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:14:13 -0400
Received: from cantor.suse.de ([195.135.220.2]:51561 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab0HBUOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:14:12 -0400
Subject: Re: linux-next: build failure after merge of the final tree
 (scsi-post-merge tree related)
From: James Bottomley <James.Bottomley@suse.de>
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
In-Reply-To: <20100802195940.GC32503@andromeda.dapyr.net>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au>
	 <20100803024701.b3dff69a.sfr@canb.auug.org.au>
	 <1280768048.2843.242.camel@mulgrave.site> <4C570464.9010204@cs.wisc.edu>
	 <20100802185925.GA32503@andromeda.dapyr.net> <4C5717E6.8010805@cs.wisc.edu>
	 <20100802195940.GC32503@andromeda.dapyr.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 15:14:02 -0500
Message-ID: <1280780042.2843.628.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-02 at 15:59 -0400, Konrad Rzeszutek Wilk wrote:
> > >Yikes. Last minute change, eh?
> > 
> > I do not know what you mean. The patches always had iscsi_boot_sysfs in 
> > the firmware dir. You mean this is a last minute change?
> 
> Yes, this rename.
> > 
> > >
> > >>interface is generic and should be used on any arch and with anything
> > >>(ibft or iscsi driver) that wants to export iscsi boot info. The
> > >>attached patch moves iscsi_boot_sysfs to drivers/scsi. It was made over
> > >>linux-next. I have only compile tested it.
> > >
> > >did you compile test it with the x86 native iBFT driver?
> > 
> > Yes.
> 
> Excellent. The patch does not look like it has changed at all, so:
> 
>  1). Signed-off-by: Konrad Rzeszutek Wilk <konrad@kernel.org>
>    for the removal from firmware/ibft, and
>  2). Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org> for the
>  the part that puts in drivers/scsi and will make it now under James'
>  mainternship.
> 
> James,
> 
> I've asked Linus to pull my iBFT tree before yours as there was this
> dependency. Are you OK putting this patch in your tree, or would you prefer
> that I expunge Mike's patch from mine?

I can put this patch into my post merge tree.  I suspect you having a
post-post-merge tree (needed for the build problems) might be a bit
overkill ...

James


