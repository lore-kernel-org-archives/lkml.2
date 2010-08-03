Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab0HCBJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 21:09:53 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:33580 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756Ab0HCBJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 21:09:52 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: James Bottomley <James.Bottomley@suse.de>
Subject: Re: linux-next: build failure after merge of the final tree (scsi-post-merge tree related)
Date: Mon, 2 Aug 2010 20:51:25 -0400
User-Agent: KMail/1.9.10
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jayamohan Kallickal <jayamohank@serverengines.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "linux-scsi" <linux-scsi@vger.kernel.org>
References: <20100803024445.0bf7ec86.sfr@canb.auug.org.au> <20100802195940.GC32503@andromeda.dapyr.net> <1280780042.2843.628.camel@mulgrave.site>
In-Reply-To: <1280780042.2843.628.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201008022051.26695.konrad@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  2). Reviewed-by: Konrad Rzeszutek Wilk <konrad@kernel.org> for the
> >  the part that puts in drivers/scsi and will make it now under James'
> >  mainternship.
> >
> > James,
> >
> > I've asked Linus to pull my iBFT tree before yours as there was this
> > dependency. Are you OK putting this patch in your tree, or would you
> > prefer that I expunge Mike's patch from mine?
>
> I can put this patch into my post merge tree.  I suspect you having a
> post-post-merge tree (needed for the build problems) might be a bit
> overkill ...
>
> James
OK. Thanks.
