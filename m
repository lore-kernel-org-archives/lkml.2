Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0JDIX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 04:23:56 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57993 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab0JDIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 04:23:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: linux-next: manual merge of the bkl-trivial tree with the hfsplus tree
Date: Mon, 4 Oct 2010 10:23:45 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.31-19-generic; KDE/4.5.1; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20101004104740.822b987d.sfr@canb.auug.org.au> <20101004033441.GA6867@lst.de>
In-Reply-To: <20101004033441.GA6867@lst.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041023.45694.arnd@arndb.de>
X-Provags-ID: V02:K0:+UVruKwOGOHUVYMjQ0nV4pGY/i6ndrSxZAhP9XhSPxJ
 VFBY7+NTj7QLvqFj1OSvBUe7VpOkiIB9KefihTzUAgZTLRgx8W
 fnMfRTI88RMtY6GOvDZAGD3zDDrFlG43DBGKkIpx+PDmVkAofP
 9AbWDKXtHKK05L5Jvga3P/qrvb2Xkpy8kpTuK3Nd6LAtEMRcPA
 7HF50L7djWHp6iqRgf9wQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 October 2010 05:34:41 Christoph Hellwig wrote:
> On Mon, Oct 04, 2010 at 10:47:40AM +1100, Stephen Rothwell wrote:
> > Hi Arnd,
> > 
> > The second of the hfsplus tree commits seems to supercede the bkl-trivial
> > one, so I used that.
> 
> Yes, the hfsplus tree contains a proper BKL removal for hfsplus.

Ok. I've removed the pushdown into hfsplus and subsequent removal from my
tree now, thanks! I've also removed the pushdown from other file systems
that are already BKL-free.

Christoph, are you planning to take care of freevxfs, too? I can't figure
out whether readdir and lookup actually need locking there.

	Arnd
