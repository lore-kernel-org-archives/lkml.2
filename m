Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932238Ab1FVOHC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 10:07:02 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34518 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932196Ab1FVOHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 10:07:00 -0400
Date: Wed, 22 Jun 2011 10:06:42 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, dan.magenheimer@oracle.com
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
Message-ID: <20110622140642.GD5574@dumpdata.com>
References: <20110622144611.a900a000.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110622144611.a900a000.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090208.4E01F6FF.0002:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 02:46:11PM +1000, Stephen Rothwell wrote:
> Hi Dan,
> 
> Today's linux-next merge of the tmem tree got a conflict in
> drivers/xen/Kconfig drivers/xen/tmem.c between commit afec6e04922d ("xen:
> prepare tmem shim to handle frontswap") from the xen-two tree and commit
> ac33c46b42ba ("xen: enable frontswap for Xen tmem") from the tmem tree.
> 

Dan, can you please rebase your #linux-next branch on my #linux-next branch
so that Stephen's awesome build engine can chug along for this?

Thanks!
> I just used the xen-two versions of these files (as they look newer).

OK, we will sort this out.
