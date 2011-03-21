Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab1CUVPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 17:15:17 -0400
Received: from cantor.suse.de ([195.135.220.2]:35731 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754628Ab1CUVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 17:15:13 -0400
Subject: Re: [RFC-v4 00/12] iSCSI target v4.1.0-rc1 series for .39-rc1
From: James Bottomley <James.Bottomley@suse.de>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>,
        Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Jesper Juhl <jj@chaosbits.net>
In-Reply-To: <1300741561.21880.22.camel@haakon2.linux-iscsi.org>
References: <1300613497-2091-1-git-send-email-nab@linux-iscsi.org>
	 <1300740867.21880.12.camel@haakon2.linux-iscsi.org>
	 <1300741629.10634.46.camel@mulgrave.site>
	 <1300741561.21880.22.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 16:15:07 -0500
Message-ID: <1300742107.10634.49.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-21 at 14:06 -0700, Nicholas A. Bellinger wrote:
> > OK ... so if you're ready, you can send the next one as a patch not rfc.
> > 
> 
> Ok, I will give 1-2 days for the final round of feedback on RFC-v4, and
> post the next series as [PATCH].  Please let me know if this should
> happen sooner in order not to miss the second round of SCSI patches
> going to Linus this week.

It's already way too late for that.  The last patches need to be in
today/tomorrow for the -next shakeout, so this will be .41 material.

James


