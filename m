Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1ASPzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:55:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:31088 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab1ASPzD (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 19 Jan 2011 10:55:03 -0500
Date: Wed, 19 Jan 2011 10:52:35 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Borislav Petkov <bp@alien8.de>, Joerg Roedel <joerg.roedel@amd.com>,
        Greg KH <greg@kroah.com>, Borislav Petkov <bp@amd64.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Borislav Petkov <borislav.petkov@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86-32: Separate 1:1 pagetables from swapper_pg_dir
Message-ID: <20110119155235.GA26134@dumpdata.com>
References: <20101022162038.GA10343@kroah.com>
 <1289483775-17632-2-git-send-email-joerg.roedel@amd.com>
 <20110119003908.GB7609@dumpdata.com>
 <20110119071944.GD13799@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119071944.GD13799@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 08:19:44AM +0100, Borislav Petkov wrote:
> On Tue, Jan 18, 2011 at 07:39:08PM -0500, Konrad Rzeszutek Wilk wrote:
> > On Thu, Nov 11, 2010 at 02:56:13PM +0100, Joerg Roedel wrote:
> 
> [..]
> 
> > > -v2: switch to swapper_pg_dir right after entering start_secondary() so
> > > that we are able to access percpu data which might not be mapped in the
> > > trampoline page table.
> > 
> > You also might want to look at the regression this patch caused when it
> > was introduced. Mainly this fix:
> > 805e3f495057aa5307ad4e3d6dc7073d4733c691
> 
> I think you mean the regression _this_
> b40827fa7268fda8a62490728a61c2856f33830b patch caused, which is not in
> -stable anyway.

Duh. Saw 'initial_page_table' and immediately jumped to conclusions.
Thank you for clarifying.
