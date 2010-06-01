Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301Ab0FANYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 09:24:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62802 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab0FANYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 09:24:18 -0400
To: Nick Piggin <npiggin@suse.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@suse.de>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: Wrong DIF guard tag on ext2 write
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20100531112817.GA16260@schmichrtp.mainz.de.ibm.com>
	<yq1iq64kv9f.fsf@sermon.lab.mkp.net>
	<1275318102.2823.47.camel@mulgrave.site>
	<4C03D5FD.3000202@panasas.com> <20100531154925.GO9453@laptop>
Date: Tue, 01 Jun 2010 09:22:42 -0400
In-Reply-To: <20100531154925.GO9453@laptop> (Nick Piggin's message of "Tue, 1
	Jun 2010 01:49:25 +1000")
Message-ID: <yq1pr0akhul.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090202.4C0509FB.00E4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Nick" == Nick Piggin <npiggin@suse.de> writes:

Nick> More complex and maybe more performant would be to avoid holding
Nick> page lock but wait_on_page_writeback in page-modification (write,
Nick> fault) paths. 

That's what I was doing last I looked at this.  I seem to recall that my
head exploded once I added buffer_heads to the mix.  And then the extfs
folks promised to take a look so I didn't mess more with it.

-- 
Martin K. Petersen	Oracle Linux Engineering
