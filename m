Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1AEQRH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 11:17:07 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58851 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab1AEQRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 11:17:05 -0500
Date: Wed, 5 Jan 2011 09:17:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>, David Miller <davem@davemloft.net>,
        Andres Salomon <dilinger@queued.net>
Subject: Re: linux-next: manual merge of the devicetree tree with the sparc
 tree
Message-ID: <20110105161700.GB17272@angua.secretlab.ca>
References: <20110105133557.dae27abf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110105133557.dae27abf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 01:35:57PM +1100, Stephen Rothwell wrote:
> Hi Grant,
> 
> Today's linux-next merge of the devicetree tree got a conflict in
> arch/sparc/prom/tree_32.c between commit
> 1f42be484ffc5559a29466c82adac7dd472d4439 ("sparc: remove unused prom tree
> functions") from the sparc tree and commit
> 4a3a255289e7e322b8044286cce85031990f888a ("sparc: explicitly cast
> negative phandle checks to s32") from the devicetree tree.
> 
> The former removes the code modified by the latter, so I just removed it.

Okay, thanks Stephen.

g.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/


