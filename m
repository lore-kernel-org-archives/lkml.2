Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab0HBUMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 16:12:13 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:48030 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754492Ab0HBUMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 16:12:10 -0400
Date: Mon, 2 Aug 2010 22:10:38 +0200
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-pcmcia@lists.infradead.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for August 2 (scsi/pcmcia)
Message-ID: <20100802201038.GB21063@comet.dominikbrodowski.net>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-pcmcia@lists.infradead.org, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
References: <20100802144432.70293bda.sfr@canb.auug.org.au>
 <20100802102707.5fbd9072.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100802102707.5fbd9072.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Mon, Aug 02, 2010 at 10:27:07AM -0700, Randy Dunlap wrote:
> pcmcia changes cause these build errors in drivers/scsi/pcmcia/nsp_cs.c:
> 
> drivers/scsi/pcmcia/nsp_cs.c:1907:1: error: unterminated argument list invoking macro "release_region"
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: 'release_region' undeclared (first use in this function)
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: (Each undeclared identifier is reported only once
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: for each function it appears in.)
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: expected ';' at end of input
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: expected declaration or statement at end of input
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: expected declaration or statement at end of input
> drivers/scsi/pcmcia/nsp_cs.c:1720: error: expected declaration or statement at end of input

ah, this driver depends on !x86_64, so my make allmodconfig run didn't catch
it... Thanks!

Should be fixed for the next -next.

Best,
	Dominik
