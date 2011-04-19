Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab1DSVpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:45:24 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60162 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344Ab1DSVpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:45:21 -0400
Date: Tue, 19 Apr 2011 22:45:04 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Baruch Siach <baruch@tkos.co.il>, linux-i2c@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next reresend] i2c: designware-pcidrv depends on PCI
Message-ID: <20110419214504.GU15795@trinity.fluff.org>
References: <20110408083215.6b3b0bfe.randy.dunlap@oracle.com> <BANLkTikX_rG+6Eg4owary1YRGRG8NzyrGQ@mail.gmail.com> <20110412114722.0f2e67d6@endymion.delvare> <20110413083855.c37ddadc.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110413083855.c37ddadc.sfr@canb.auug.org.au>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 08:38:55AM +1000, Stephen Rothwell wrote:
> Hi Jean, Ben,
> 
> On Tue, 12 Apr 2011 11:47:22 +0200 Jean Delvare <khali@linux-fr.org> wrote:
> >
> > On Sat, 9 Apr 2011 13:34:49 +0200, Geert Uytterhoeven wrote:
> > > On Fri, Apr 8, 2011 at 17:32, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > >
> > > > i2c-designware-pcidrv is a PCI driver and should depend on PCI.
> > > > Fixes these build errors:
> > > >
> > > > drivers/i2c/busses/i2c-designware-pcidrv.c:256: error: implicit declaration of function 'pci_request_region'
> > > > drivers/i2c/busses/i2c-designware-pcidrv.c:338: error: implicit declaration of function 'pci_release_region'
> > > >
> > > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > > > Cc: Baruch Siach <baruch@tkos.co.il>
> > > > ---
> > > >  drivers/i2c/busses/Kconfig |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > >
> > > > Does anybody merge i2c patches???
> > > 
> > > Yes please, it's been there since Mar 17, reported several times, and probably
> > > masking other build failures.
> > 
> > This bug only exists in linux-next, as the code in question wasn't
> > merged in Linus's tree yet. It is drawn into linux-next from Ben
> > Dooks's next-i2c branch:
> >   http://git.fluff.org/gitweb?p=bjdooks/linux.git;a=shortlog;h=refs/heads/next-i2c
> > 
> > This is where it has to be fixed, so only Ben can do it. Ben, please?
> > 
> > Meanwhile, it should be possible to apply a hot fix to linux-next
> > directly, Stephen does it pretty often. Stephen, could you please apply
> > this fix temporarily until Ben wakes up and applies it to his tree?
> 
> I will apply this patch as a merge fixup from today (if it is still
> needed).  I also have a patch being applied to that tree to add an
> include of linux/delay.h to drivers/i2c/busses/i2c-designware-core.c .

I've not gotten around to fixing the rebase of the driver to the
latest source code, I'll try and get around to it in the next few
days unless someone sends a new copy of the patch.
 
> Ben?
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> http://www.canb.auug.org.au/~sfr/

-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

