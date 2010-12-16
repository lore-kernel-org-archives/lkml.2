Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0LPXuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:50:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:56244 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0LPXuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:50:54 -0500
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org,
        Alasdair G Kergon <agk@redhat.com>, stable@kernel.org
Subject: Re: [PATCH for-2.6.37] block: max hardware sectors limit wrapper
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20101206184346.GA13582@redhat.com>
Date: Thu, 16 Dec 2010 18:49:18 -0500
In-Reply-To: <20101206184346.GA13582@redhat.com> (Mike Snitzer's message of
	"Mon, 6 Dec 2010 13:43:46 -0500")
Message-ID: <yq1wrn92s8x.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Implement blk_limits_max_hw_sectors() and make
Mike> blk_queue_max_hw_sectors() a wrapper around it.

Mike> DM needs this to avoid setting queue_limits' max_hw_sectors and
Mike> max_sectors directly.  dm_set_device_limits() now leverages
Mike> blk_limits_max_hw_sectors() logic to establish the appropriate
Mike> max_hw_sectors minimum (PAGE_SIZE).  Fixes issue where DM was
Mike> incorrectly setting max_sectors rather than max_hw_sectors (which
Mike> caused dm_merge_bvec()'s max_hw_sectors check to be ineffective).

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

Jens, please apply.

-- 
Martin K. Petersen	Oracle Linux Engineering
