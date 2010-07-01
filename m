Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab0GAMuJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 08:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753876Ab0GAMuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 08:50:06 -0400
Date: Thu, 1 Jul 2010 13:49:12 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: James Bottomley <James.Bottomley@suse.de>, axboe@kernel.dk,
       Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       device-mapper development <dm-devel@redhat.com>,
       martin.petersen@oracle.com, akpm@linux-foundation.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [dm-devel] [PATCH 1/2] block: fix leaks associated with
	discard request payload
Message-ID: <20100701124912.GD23989@agk-dp.fab.redhat.com>
Mail-Followup-To: Mikulas Patocka <mpatocka@redhat.com>,
	James Bottomley <James.Bottomley@suse.de>, axboe@kernel.dk,
	Mike Snitzer <snitzer@redhat.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>,
	martin.petersen@oracle.com, akpm@linux-foundation.org,
	Christoph Hellwig <hch@lst.de>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com> <1277652576.4366.19.camel@mulgrave.site> <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com> <1277852600.4379.211.camel@mulgrave.site> <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com> <1277907738.2839.9.camel@mulgrave.site> <Pine.LNX.4.64.1007010803040.18570@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1007010803040.18570@hs20-bc2-1.build.redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 08:28:02AM -0400, Mikulas Patocka wrote:
> But this is the same thing that you are doing with SCSI.

Have you read these patches, Mikulas?  Stop digging.

Alasdair

