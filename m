Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1BVQsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:48:08 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:21320 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509Ab1BVQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:48:05 -0500
To: djwong@us.ibm.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Mingming Cao <mcao@us.ibm.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [RFC] block integrity: Fix write after checksum calculation problem
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20110222020022.GH32261@tux1.beaverton.ibm.com>
Date: Tue, 22 Feb 2011 11:45:44 -0500
In-Reply-To: <20110222020022.GH32261@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Mon, 21 Feb 2011 18:00:22 -0800")
Message-ID: <yq1vd0cf26f.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110013 (No Gnus v0.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D63E875.004F:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:

Darrick> Unfortunately, I didn't get a sense that any sort of consensus
Darrick> had been reached

We had a session on this topic at the storage workshop in Auguest. The
consensus was that filesystems really need to handle this.

Also, DIX is only the tip of the iceberg. Many other impending
technologies feature checksums and require pages to be stable during I/O
due to checksumming, encryption and so on.

The VM is already trying to do the right thing. We just need the
relevant filesystems to catch up.

-- 
Martin K. Petersen	Oracle Linux Engineering
