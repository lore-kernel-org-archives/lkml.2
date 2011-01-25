Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1AYB14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:27:56 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:46472 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1AYB1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:27:55 -0500
Subject: Re: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1295915790.15425.44.camel@mulgrave.site>
References: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
	 <1295915790.15425.44.camel@mulgrave.site>
Content-Type: text/plain
Date: Mon, 24 Jan 2011 17:27:51 -0800
Message-Id: <1295918871.24778.161.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 18:36 -0600, James Bottomley wrote:
> On Mon, 2011-01-24 at 16:14 -0800, Nicholas A. Bellinger wrote:
> > Hi James and Co,
> > 
> > Here are the latest v4.0.0-rc7 updates for mainline drivers/target/ code
> > rebased against linux-2.6.git -> .38-rc2.  These individual patches have
> > been reviewed on linux-scsi and commited into the upstream LIO kernel
> > tree, so please consider pulling for .38-rc3:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc3
> > 
> > Also at this point, having Linus pull directly from
> > scsi-post-merge-2.6.git/for-38-rcX for mainline target bugfixes +
> > improvements may make more sense.
> > 
> > Linus/Andrew/James, please let me know which you prefer here.
> 
> Right at the moment, I'm trying to encourage a few people with
> established areas to experiment with their own git trees in SCSI, but
> the target subsystem, being a newcomer, wouldn't be one of these, so,
> for the time being, patch series over linux-scsi please for review and
> feedback.
> 

Sure, thanks for the clarification.  The same set of patches are
available against your .37-FINAL based scsi-post-merge-2.6.git/master
HEAD here:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-jejb

Please let me know if you have any further questions,

--nab


