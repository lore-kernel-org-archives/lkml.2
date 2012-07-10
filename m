Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2GJTLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 15:11:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53874 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab2GJTLJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 15:11:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,561,1336374000"; 
   d="scan'208";a="661237309"
From: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
To: Mike Snitzer <snitzer@redhat.com>
CC: "axboe@kernel.dk" <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Stankey, Robert" <Robert.Stankey@netapp.com>,
        "Moger, Babu" <Babu.Moger@netapp.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: RE: [PATCH v2] block: do not artificially constrain max_sectors for
 stacking drivers
Thread-Topic: [PATCH v2] block: do not artificially constrain max_sectors
 for stacking drivers
Thread-Index: AQHNXeMkNIJR1jDBlUygj7irF7xnYpciBfuAgADcegA=
Date: Tue, 10 Jul 2012 19:10:51 +0000
Message-ID: <F200AD42A082BC4088B232D13A916A8907E5F2AA@SACEXCMBX02-PRD.hq.netapp.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
 <20120709130052.GC30048@redhat.com> <20120709131611.GD30048@redhat.com>
 <20120709134041.GA30633@redhat.com> <20120709141416.GB30633@redhat.com>
 <20120709145711.GB30886@redhat.com> <20120709225725.GA1487@redhat.com>
In-Reply-To: <20120709225725.GA1487@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.106.53.53]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 10, 2012 4:27 AM, Mike Wrote:
>As it happens, v2's changes to blk_limits_max_hw_sectors and
>blk_queue_max_hw_sectors are not strictly required in order for existing
>stacking drivers to have have an unconstrained max_sectors.  Dropping
>those changes also allows for consistency across both block functions.
>
>So I'd be happy if v1 were to be staged for 3.6.  NetApp: it would be
>great if you could confirm that v1 does in fact address the max_sectors
>issue you reported.
>
>Thanks,
>Mike

Mike, Thanks for the quick fix. I verified with Patch v1 and it resolves this issue.

Thanks,
Vijay
