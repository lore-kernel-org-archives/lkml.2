Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1IDRSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 13:18:33 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53568 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1IDRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 13:18:26 -0400
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, djwong@us.ibm.com,
        "Greg Freemyer" <greg.freemyer@gmail.com>,
        "Andreas Dilger" <adilger.kernel@dilger.ca>,
        "Theodore Tso" <tytso@mit.edu>,
        "Sunil Mushran" <sunil.mushran@oracle.com>,
        "Amir Goldstein" <amir73il@gmail.com>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Mingming Cao" <cmm@us.ibm.com>, "Joel Becker" <jlbec@evilplan.org>,
        "linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, "Coly Li" <colyli@gmail.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	<CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
	<20110902182214.GC12086@tux1.beaverton.ibm.com>
	<yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
	<6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
Date: Sun, 04 Sep 2011 13:17:27 -0400
In-Reply-To: <6fdb58aed1dae8020900e65cbfb34b28.squirrel@www.firstfloor.org>
	(Andi Kleen's message of "Sun, 4 Sep 2011 18:54:28 +0200")
Message-ID: <yq14o0scjmg.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4E63B2D1.007D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andi" == Andi Kleen <andi@firstfloor.org> writes:

>> On Westmere and beyond it is possible to accelerate generic CRC
>> calculation using the PCLMULQDQ operation. There are many of our CRC

Andi> Faster than the lookup table? That's hard to believe.

Using PCLMULQDQ you can parallelize the calculation. You can even boost
hw CRC32C performance that way.

  http://download.intel.com/design/intarch/papers/323405.pdf

  http://download.intel.com/design/intarch/papers/323102.pdf

-- 
Martin K. Petersen	Oracle Linux Engineering
