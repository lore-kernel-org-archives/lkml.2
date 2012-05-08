Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2EHKA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:00:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:58902 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2EHKA5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:00:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140258933"
From: "Patelczyk, Maciej" <maciej.patelczyk@intel.com>
To: Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
CC: "neilb@suse.de" <neilb@suse.de>
Subject: RE: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Thread-Topic: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
Thread-Index: AQHNA0dtZSpq7DbamUWBLG6bsL1Kb5a/+XSg
Date: Tue, 8 May 2012 09:59:58 +0000
Message-ID: <679865E03F4C71419D9847EA3AACB163157D4CE6@IRSMSX102.ger.corp.intel.com>
References: <20120316073213.656519005@fusionio.com>
In-Reply-To: <20120316073213.656519005@fusionio.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Shaohua Li
> Sent: Friday, March 16, 2012 8:32 AM
> To: linux-kernel@vger.kernel.org; linux-raid@vger.kernel.org
> Cc: neilb@suse.de; axboe@kernel.dk; vgoyal@redhat.com;
> martin.petersen@oracle.com
> Subject: [patch v2 0/6] Add TRIM support for raid linear/0/1/10
> 
> The patches add TRIM support for raid linear/0/1/10. I'll add TRIM
> support for raid 4/5/6 later. The implementation is pretty
> straightforward and self-explained.
> 
> v1->v2:
> 1. fixed a checking issue
> 2. dropped discard request plug and replace it with no discard merege,
> because current SCSI layer can't handle discard request merge.
> 
> Thanks,
> Shaohua

Hi,
Can't see anywhere patch 2/6 from this series.


maciej
