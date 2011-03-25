Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab1CYUfW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 16:35:22 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:22557
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849Ab1CYUfT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 16:35:19 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zzbb2cK4015Lzz1202hzz8275bhz2dh95h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: xilinx linux-next tree addition request
Date: Fri, 25 Mar 2011 14:35:12 -0600
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: xilinx linux-next tree addition request
Thread-Index: AcvrLCQnUAIL6T7xRDCJ7+Y3wtxc6A==
From: John Linn <John.Linn@xilinx.com>
To: <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: Grant Likely <grant.likely@secretlab.ca>
X-OriginalArrivalTime: 25 Mar 2011 20:35:14.0412 (UTC) FILETIME=[251FCAC0:01CBEB2C]
X-RCIS-Action: ALLOW
Message-ID: <58f8b399-ac49-484c-9e99-d23bcda08a8b@VA3EHSMHS024.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I have a tree I'd like to see show up in linux-next: 

git://git.xilinx.com/linux-2.6-xlnx.git arm-next 

After v2.6.39-rc1 is released, it will contain Xilinx ARM work intended
for the 2.6.40 merge window.  Everything in there has been posted,
reviewed, fixed, etc...

If order makes a difference, it would be best if it's after Russell's
tree as it could have dependencies on stuff in his tree.

It is only Linus's linux-2.6 tree right now, but I wanted to get this
all staged up and ready.

Thanks,
John   





This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


