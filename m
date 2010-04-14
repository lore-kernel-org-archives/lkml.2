Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679Ab0DNO1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:27:19 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:48836 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0DNO1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:27:17 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Frank Ren" <frankrq2009@gmx.com>, "mingo" <mingo@elte.hu>,
       "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
       "jens.axboe" <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, dm-devel@redhat.com,
       Alasdair G Kergon <agk@redhat.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: high iowait problem(Bug 12309 on bugzilla.kernel.org)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100331124834.192500@gmx.com>
	<20100413135416.b537eee8.akpm@linux-foundation.org>
Date: Wed, 14 Apr 2010 10:25:08 -0400
In-Reply-To: <20100413135416.b537eee8.akpm@linux-foundation.org> (Andrew
	Morton's message of "Tue, 13 Apr 2010 13:54:16 -0700")
Message-ID: <yq1sk6yjem3.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BC5D056.00E5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andrew" == Andrew Morton <akpm@linux-foundation.org> writes:

Andrew> I'm seeing just one device-mapper change whcih went in over that
Andrew> timeframe:

Andrew> : commit e0f5cfa7c18b411634e73923841eccd3a4c0ce7f
Andrew> : Author: Martin K. Petersen <martin.petersen@oracle.com>
Andrew> : Date:   Mon Jan 11 03:21:50 2010 -0500
Andrew> : 
Andrew> :     DM: Fix device mapper topology stacking

The topology changes do not modify anything in our runtime I/O path.
They only come into play during filesystem or logical volume creation on
top of devices that support reporting alignment/physical block size.
And you need recent dm and filesystem utilities for that to work.

-- 
Martin K. Petersen	Oracle Linux Engineering
