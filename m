Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab2DRHRa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 03:17:30 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:34576 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2DRHR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 03:17:28 -0400
Subject: Re: [PATCH v3 00/11] firewire-sbp-target: FireWire SBP-2 SCSI
 target
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de, Christoph Hellwig <hch@lst.de>
In-Reply-To: <4F8D4A95.8070103@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
	 <1334154043-69076-1-git-send-email-bootc@bootc.net>
	 <1334286222.3137.4877.camel@haakon2.linux-iscsi.org>
	 <4F882745.4080301@bootc.net>
	 <1334366583.12540.12.camel@haakon2.linux-iscsi.org>
	 <4F8D4A95.8070103@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Apr 2012 00:17:26 -0700
Message-ID: <1334733446.15333.7.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-17 at 11:48 +0100, Chris Boot wrote:
> On 14/04/2012 02:23, Nicholas A. Bellinger wrote:

<SNIP>

> > I was eager to see this change, so I decided to go ahead and do the
> > mechanical conversion myself in the following branch:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/lio-core.git sbp-merge
> >
> > As mentioned, it converts drivers/target/sbp/ to use a single sbp_target.[c,h]
> > source/header file following mainline convention for new target fabric
> > drivers.  Also make as many functions as possible statically defined and
> > add inline prototypes where necessary.
> >
> > This patch also renames the sbp-target config entry from:
> >
> >      FIREWIRE_SBP_TARGET ->  SBP_TARGET
> >
> > and also renames the final generated module name from:
> >
> >      fireware-sbp-target.ko ->  sbp_target.ko
> 
> Nick,
> 
> I only just noticed this, but it looks like your merge lost my changed 
> to the MAINTAINERS file. Want me to send a fixup patch?
> 

Whoops, sorry about that Chris.  I'll be sure to get this fixed up in
the next target-pending update.

Thanks!

--nab

