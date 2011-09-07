Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752509Ab1IGQai (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:30:38 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:38078 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752426Ab1IGQaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:30:35 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=bMtn2c2igAkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=HfED7Bf4rwdySxPrFWsA:9 a=M4iLqScXN50zkFVMTO4A:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        <fzago@systemfabricworks.com>, "'George Spelvin'" <linux@horizon.com>,
        <linux-kernel@vger.kernel.org>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com>	<20110902165047.6aaec238.akpm@linux-foundation.org>	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>	<20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au> <20110906123851.dc4de9f5.akpm@linux-foundation.org> 
In-Reply-To: 
Subject: RE: [PATCH v6 05/10] crc32-misc-cleanup.diff
Date: Wed, 7 Sep 2011 11:30:31 -0500
Message-ID: <035901cc6d7b$77065350$6512f9f0$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJdND57YfohkECc5nAnrPUtKDDU5gJZZUhmAFIMxcECHqI1yQJliP+MAsOhF3oCTbCit5O9L1MQgAFVY0A=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> The list of needed changes based on recent comments I am aware of are:
>  - put back in a couple of header files per Andrew
>  - fix the summary phrases to conform to coding standards per Andrew
>  - add signed off by for Joakim to patch 04/10 per Joakim
>  - fix bug in patch 06/10 noted in my email by passing bits as a parameter
to
> crc32_body
Adding three additional changes:
 - update macro per Joakim
 - shorter generator code per George
 - remove unneeded local_irq_disable per Andrew
Any more?

Can we finish crc32 before we start boiling the ocean with crc32c, crc16
etc.? I am happy to pitch in on those but I would like to see something
actually get done. I actually need this one.


