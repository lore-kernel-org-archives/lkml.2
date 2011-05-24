Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab1EXGT2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:19:28 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39263 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab1EXGT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:19:26 -0400
Subject: Re: [PATCH-v2] MAINTAINERS: Add drivers/target/ entry
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joe Perches <joe@perches.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
In-Reply-To: <1306193789.8687.61.camel@Joe-Laptop>
References: <1306185032-11629-1-git-send-email-nab@linux-iscsi.org>
	 <1306193789.8687.61.camel@Joe-Laptop>
Content-Type: text/plain
Date: Mon, 23 May 2011 23:11:09 -0700
Message-Id: <1306217469.29724.150.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-23 at 16:36 -0700, Joe Perches wrote:
> On Mon, 2011-05-23 at 14:10 -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > +TARGET SUBSYSTEM
> > +M:	Nicholas A. Bellinger <nab@linux-iscsi.org>
> > +L:	linux-scsi@vger.kernel.org
> > +L:	http://groups.google.com/group/linux-iscsi-target-dev
> > +W:	http://www.linux-iscsi.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core-2.6.git master
> > +S:	Supported
> > +F:	drivers/target/
> > +F:	include/target/
> > +F:	Documentation/target/
> 
> Shouldn't the file layout be more like
> 
> drivers/lio/target?
> 

Hi Joe,

Not sure what you mean here..  Currently drivers/target/ contains the
fabric independent target core, and /drivers/target/$FABRIC/ contains
individual fabric module drivers.

I originally decided to use drivers/target/ to avoid any confusion wrt
to the 'LIO' term, which to some folks is interchangable wrt to the
'iscsi-target' fabric module.

--nab

