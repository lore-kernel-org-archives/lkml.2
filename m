Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1F2PQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 11:16:16 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:52517 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755346Ab1F2PQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 11:16:12 -0400
X-Sasl-enc: C3n4suUnpkPll4jXuQApfWmpEhj7Kj49wvoYlhH88sOP 1309360571
Date: Wed, 29 Jun 2011 08:14:24 -0700
From: Greg KH <greg@kroah.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, David Miller <davem@davemloft.net>,
        akpm@linux-foundation.org, alan@linux.intel.com, bcasavan@sgi.com,
        airlied@linux.ie, grundler@parisc-linux.org, perex@perex.cz,
        rpurdie@rpsys.net, klassert@mathematik.tu-chemnitz.de, tj@kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, linux-scsi@vger.kernel.org,
        linux-serial@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/12] Fix various section mismatches and build errors.
Message-ID: <20110629151424.GD18023@kroah.com>
References: <17dd5038b15d7135791aadbe80464a13c80758d3.1309182742.git.ralf@linux-mips.org>
 <20110627.221257.1290251511587162468.davem@davemloft.net>
 <20110629130711.GA15649@linux-mips.org>
 <1309355899.2551.4.camel@mulgrave>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309355899.2551.4.camel@mulgrave>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 08:58:19AM -0500, James Bottomley wrote:
> I think we should simply concentrate on __init and __exit; that's where
> most of the discard value lies and stop expending huge efforts on the
> __devX stuff which adds huge complexity for no real gain.

I have long felt that those __devX markings should just go away as they
cause nothing but problems and have no real gain as you point out.

greg k-h
