Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0F2IA5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:00:57 -0400
Received: from daytona.panasas.com ([67.152.220.89]:48097 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751069Ab0F2IAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:00:55 -0400
Message-ID: <4C29A833.1060704@panasas.com>
Date: Tue, 29 Jun 2010 11:00:51 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: James Bottomley <James.Bottomley@suse.de>,
       Mike Snitzer <snitzer@redhat.com>, Christoph Hellwig <hch@lst.de>,
       axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, linux-scsi@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 1/2] block: fix leaks associated with discard request
 payload
References: <20100622180029.GA15950@redhat.com>	<1277582211-10725-1-git-send-email-snitzer@redhat.com>	<1277652576.4366.19.camel@mulgrave.site> <yq1sk47dqmd.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1sk47dqmd.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Jun 2010 08:00:54.0485 (UTC) FILETIME=[32FC4050:01CB1761]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 08:16 PM, Martin K. Petersen wrote:
> I'm still dreaming of the day where libata moves out from under SCSI so
> we don't have to translate square pegs into round holes...
> 

Hi Martin.

Is that on the Radar still? what would you say are the major issues holding
it back?

* Is it just the missing new ULD, Will we be using a new ULD?
* Is it the ata midlayer that would duplicate some of scsi-midlayer.
  (Not so much these days, lots of good code went into blk_rq_)
* Is it the distro's setup procedures changing yet again back to the
  hd vs sd times.

Thanks
Boaz
