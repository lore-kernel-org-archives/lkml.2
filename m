Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1EXGnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:43:43 -0400
Received: from mail.perches.com ([173.55.12.10]:1940 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab1EXGnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:43:42 -0400
Subject: Re: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
From: Joe Perches <joe@perches.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1306217469.29724.150.camel@haakon2.linux-iscsi.org>
References: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
	 <1306193789.8687.61.camel@Joe-Laptop>
	 <1306217469.29724.150.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 May 2011 23:43:40 -0700
Message-ID: <1306219420.2298.12.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 23:11 -0700, Nicholas A. Bellinger wrote:
> On Mon, 2011-05-23 at 16:36 -0700, Joe Perches wrote:
> > On Mon, 2011-05-23 at 14:10 -0700, Nicholas A. Bellinger wrote:
> > > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > > +TARGET SUBSYSTEM
> > > +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> > > +L:	linux-scsi@vger.kernel.org
> > > +L:	http://groups.google.com/group/linux-iscsi-target-dev
> > > +W:	http://www.linux-iscsi.org
> > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> > > +S:	Supported
> > > +F:	drivers/target/
> > > +F:	include/target/
> > > +F:	Documentation/target/
> > 
> > Shouldn't the file layout be more like
> > drivers/lio/target?
> Hi Joe,

Hi Nicholas.

> Not sure what you mean here..  Currently drivers/target/ contains the
> fabric independent target core, and /drivers/target/$FABRIC/ contains
> individual fabric module drivers.
> 
> I originally decided to use drivers/target/ to avoid any confusion wrt
> to the 'LIO' term, which to some folks is interchangable wrt to the
> 'iscsi-target' fabric module.

Target doesn't mean much to me and the wiki calls the
system LIO.

http://linux-iscsi.org/wiki/Main_Page

I think that drivers/target might be better renamed to
drivers/lio/target and drivers/lio/target/$FABRIC could
be below that.

No worries if you think otherwise.

cheers, Joe

