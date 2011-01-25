Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab1AYAgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:36:35 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40756 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529Ab1AYAge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:36:34 -0500
Subject: Re: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
References: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 18:36:30 -0600
Message-ID: <1295915790.15425.44.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-24 at 16:14 -0800, Nicholas A. Bellinger wrote:
> Hi James and Co,
> 
> Here are the latest v4.0.0-rc7 updates for mainline drivers/target/ code
> rebased against linux-2.6.git -> .38-rc2.  These individual patches have
> been reviewed on linux-scsi and commited into the upstream LIO kernel
> tree, so please consider pulling for .38-rc3:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc3
> 
> Also at this point, having Linus pull directly from
> scsi-post-merge-2.6.git/for-38-rcX for mainline target bugfixes +
> improvements may make more sense.
> 
> Linus/Andrew/James, please let me know which you prefer here.

Right at the moment, I'm trying to encourage a few people with
established areas to experiment with their own git trees in SCSI, but
the target subsystem, being a newcomer, wouldn't be one of these, so,
for the time being, patch series over linux-scsi please for review and
feedback.

James


