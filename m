Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2IGRh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 13:37:57 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42025 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751977Ab2IGRhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 13:37:50 -0400
Date: Fri, 7 Sep 2012 12:38:09 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ashley Lai <adlai@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        rcj@linux.vnet.ibm.com, adlai@us.ibm.com,
        James Morris <jmorris@namei.org>
Subject: Re: [PATCH V3 1/3] drivers/char/tpm: Add new device driver to
 support IBM vTPM
Message-ID: <20120907173809.GA19704@linux.vnet.ibm.com>
References: <1344987282.4430.26.camel@footlong>
 <1345670263.25124.7.camel@footlong>
 <20120822214217.GB13519@linux.vnet.ibm.com>
 <1346816407.2257.37.camel@pasglop>
 <20120905154644.GA14925@linux.vnet.ibm.com>
 <1346879505.19098.3.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346879505.19098.3.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12090717-7182-0000-0000-000002898409
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >   James did accept my pull request, so these are already in
> > security-next...
> 
> For the driver itself, it's not a big issue (though I did found issue
> while reviewing it so it will need another round of updates). For the
> code that changes arch/powerpc, especially prom_init.c, that stuff must
> at the very least be acked by me (or the acting powerpc person if I'm
> away) if it's going to go via a different tree.

  Sorry about that.  Hopefully there won't be any changes there and we
can amend with your ack.

  As for the driver updates, I'd hate to see everyone else's code in the
pull request get delayed yet again.  James, will it be ok to apply the
update on top of security-next?

Thanks,
Kent

> Cheers,
> Ben.
> 

