Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0GAOEK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:04:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28717 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0GAOEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:04:08 -0400
Date: Thu, 1 Jul 2010 10:03:43 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@hs20-bc2-1.build.redhat.com
To: Mike Snitzer <snitzer@redhat.com>
cc: James Bottomley <James.Bottomley@suse.de>,
       device-mapper development <dm-devel@redhat.com>, axboe@kernel.dk,
       linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
In-Reply-To: <20100701124609.GA19605@redhat.com>
Message-ID: <Pine.LNX.4.64.1007010959320.8472@hs20-bc2-1.build.redhat.com>
References: <20100622180029.GA15950@redhat.com> <1277582211-10725-1-git-send-email-snitzer@redhat.com>
 <1277652576.4366.19.camel@mulgrave.site> <Pine.LNX.4.64.1006291811300.27462@hs20-bc2-1.build.redhat.com>
 <1277852600.4379.211.camel@mulgrave.site> <Pine.LNX.4.64.1006291925480.11847@hs20-bc2-1.build.redhat.com>
 <1277907738.2839.9.camel@mulgrave.site> <Pine.LNX.4.64.1007010803040.18570@hs20-bc2-1.build.redhat.com>
 <20100701124609.GA19605@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Mikulas,
> 
> Jens has already queued up a comprehensive fix (3 patches) that James
> and Tomo developed.  Please stop the hostility.. it has no place.
> 
> Others,
> I'd encourage you to not respond to this thread further ;)
> 
> Regards,
> Mike

I read mailing lists at longer intervals than my mailbox, so I read the 
James' message I responded to but missed the patches on the list. It's 
good that it's fixed and there is no need to argue about it anymore.

Mikulas
