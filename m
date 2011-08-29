Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab1H2IHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:07:25 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:56632 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab1H2IHV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:07:21 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz936eK148cM1432N98dKzz1202hzzz2ei2a8h668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPVD:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
From: Giridhar Malavali <giridhar.malavali@qlogic.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Chad Dupuis <chad.dupuis@qlogic.com>
Date: Mon, 29 Aug 2011 01:07:16 -0700
Subject: Re: linux-next: build failure after merge of the scsi tree
Thread-Topic: linux-next: build failure after merge of the scsi tree
Thread-Index: AcxmIqtWO4xL2SLnTM+1gK0kITfAMw==
Message-ID: <CA809449.296D8%giridhar.malavali@qlogic.com>
In-Reply-To: <1314602256.5038.1.camel@dabdike>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.10.0.110310
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>

>On Mon, 2011-08-29 at 12:09 +1000, Stephen Rothwell wrote:
>> Hi James,
>> 
>> After merging the scsi tree, today's linux-next build (powerpc
>> ppc64_defconfig) failed like this:
>> 
>> drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_alloc':
>> drivers/scsi/qla2xxx/qla_nx.c:4815:2: error: implicit declaration of
>>function 'vmalloc'
>> drivers/scsi/qla2xxx/qla_nx.c:4815:14: warning: assignment makes
>>pointer from integer without a cast
>> drivers/scsi/qla2xxx/qla_nx.c: In function 'qla82xx_md_free':
>> drivers/scsi/qla2xxx/qla_nx.c:4845:3: error: implicit declaration of
>>function 'vfree'
>> 
>> Caused by commit b60bb5832c00 ("[SCSI] qla2xxx: Add support for ISP82xx
>> to capture dump (minidump) on failure").  Missing include of
>> linux/vmalloc.h.  See Rule 1 in Documentation/SubmitChecklist.
>> 
>> I have used the scsi tree from next-20110826 for today.
>
>Thanks for finding the problem.  I updated the commit with a simple fix
>and re-pushed.

Thanks James and Stephen for finding and fixing this problem. I will make
sure that such issues won't happen in future.

-- Giri

>
>James
>
>
>


