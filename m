Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2EWIzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:55:46 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:7428
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750895Ab2EWIzm convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:55:42 -0400
X-Forefront-Antispam-Report: CIP:198.70.193.64;KIP:(null);UIP:(null);IPV:NLI;H:avexcashub1.qlogic.com;RD:avexcashub2.qlogic.com;EFVD:NLI
X-SpamScore: -12
X-BigFish: VPS-12(zz542M1432N98dKzz1202hzz8275eh8275bh8275dha1495iz2ei2a8h668h839h944he5bhf0ah)
From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
To: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Lalit Chandivade <lalit.chandivade@qlogic.com>,
        Ravi Anand <ravi.anand@qlogic.com>
Date: Wed, 23 May 2012 01:55:36 -0700
Subject: Re: Bug in sysfs bin attribute?
Thread-Topic: Bug in sysfs bin attribute?
Thread-Index: Ac04wdLMu7N3dS2zT3+N6IUot6srPg==
Message-ID: <CBE2A210.EF14%vikas.chaudhary@qlogic.com>
In-Reply-To: <20120523061712.GA19773@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.2.2.120421
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: qlogic.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie
<michaelc@cs.wisc.edu>, James Bottomley
<James.Bottomley@HansenPartnership.com>, Lalit Chandivade
<lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>
Subject: Re: Bug in sysfs bin attribute?

>On Tue, May 22, 2012 at 10:38:11PM -0700, Vikas Chaudhary wrote:
>>
>> We have added sysfs bin_attribute 'fw_dump' in qla4xxx driver.
>> Here is patch for same: -
>> http://marc.info/?l=linux-scsi&m=133733192809849&w=2
>>
>>
>> In this patch in function qla4_8xxx_sysfs_write_fw_dump() if we print
>> string coming in 'char *buf'
>> from sysfs attribute it contain value we echo on sysfs attribute
>>'fw_dump'
>> plus some garbage data.
>
>Why are you not using the built-in firmware interface the kernel
>provides you?  What does it lack that you need here?

In this patch we are not trying to load firmware, Here we are trying to
collect
firmware dump in case of adapter firmware crash. The firmware dump is in
driver buffer
and we want to extract it at user space using the sysfs bin attribute.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

