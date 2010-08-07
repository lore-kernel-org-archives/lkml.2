Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab0HGIOc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 04:14:32 -0400
Received: from avexcashub1.qlogic.com ([198.70.193.61]:26426 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HGIO3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 04:14:29 -0400
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Karen Higgins <karen.higgins@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>,
        James Bottomley <James.Bottomley@suse.de>
Date: Sat, 7 Aug 2010 01:13:12 -0700
Subject: RE: linux-next: build warnings in Linus'  tree
Thread-Topic: linux-next: build warnings in Linus'  tree
Thread-Index: Acs11z8uoc4A85r2Q0mi6dQFDQ5HdQAMDEwA
Message-ID: <5E4F49720D0BAD499EE1F01232234BA87128E7CBE3@AVEXMB1.qlogic.org>
References: <20100807122116.e6421ea0.sfr@canb.auug.org.au>
In-Reply-To: <20100807122116.e6421ea0.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Stephen Rothwell [mailto:sfr@canb.auug.org.au]
>Sent: Saturday, August 07, 2010 7:51 AM
>To: Vikas Chaudhary
>Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Karen
>Higgins; Ravi Anand; James Bottomley
>Subject: linux-next: build warnings in Linus' tree
>
>Hi all,
>
>today's linux-next build (x86_64 allmodconfig) of Linus' tree produced
>these warnings:
>
>drivers/scsi/qla4xxx/ql4_nx.c: In function 'qla4_8xxx_get_flash_info':
>drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'mid' may be used
>uninitialized in this function
>drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'mid' was declared here
>drivers/scsi/qla4xxx/ql4_nx.c:1952: warning: 'fid' may be used
>uninitialized in this function
>drivers/scsi/qla4xxx/ql4_nx.c:1952: note: 'fid' was declared here
>
>Introduced by commit f4f5df23bf72208d0c2f1d8be629839924c2f4c2 ("[SCSI]
>qla4xxx: Added support for ISP82XX").  I don't think that these are false
>positives.
>

Yes, Sorry. I am sending patch in next mail on top of latest
scsi-misc-2.6 tree to fix this warning. 

>--
>Cheers,
>Stephen Rothwell                    sfr@canb.auug.org.au
>http://www.canb.auug.org.au/~sfr/
