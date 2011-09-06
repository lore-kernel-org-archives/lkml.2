Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1IFUSo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 16:18:44 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:40207 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754854Ab1IFUSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 16:18:38 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=bMtn2c2igAkA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=I1F__zEsIdw5GxcaiBcA:9 a=jRnCBcFTirTULPU3t4AA:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Stephen Rothwell'" <sfr@canb.auug.org.au>
Cc: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        <fzago@systemfabricworks.com>, "'George Spelvin'" <linux@horizon.com>,
        <linux-kernel@vger.kernel.org>
References: <20110831213729.395283830@systemfabricworks.com>	<4E5EB5F4.6010105@systemfabricworks.com>	<20110902165047.6aaec238.akpm@linux-foundation.org>	<20110903114403.027a9563c86eeaf1c0e4e80b@canb.auug.org.au>	<OF0B1D5F8A.D8D66C8A-ONC1257903.004A257F-C1257903.004B1700@transmode.se>	<20110907005013.e96fb5acd9f4b7c06ee70972@canb.auug.org.au> <20110906123851.dc4de9f5.akpm@linux-foundation.org>
In-Reply-To: <20110906123851.dc4de9f5.akpm@linux-foundation.org>
Subject: RE: [PATCH v6 05/10] crc32-misc-cleanup.diff
Date: Tue, 6 Sep 2011 15:18:35 -0500
Message-ID: <02a401cc6cd2$28ee4e60$7acaeb20$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJdND57YfohkECc5nAnrPUtKDDU5gJZZUhmAFIMxcECHqI1yQJliP+MAsOhF3oCTbCit5O9L1MQ
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Yup.  lib-crc-add-slice-by-8-algorithm-to-crc32c.patch is dead meat.  I
> sometimes keep things like that around to get them a bit of testing
> while reminding myself that there's an open issue to track.

I thought I was getting close until recently someone sent out a patch set
for crc32c.c, the other 32 bit CRC in common use, based on an earlier
version of the changes we have been working on for crc32.c. This has brought
in other interested parties and created a bit of duplicated code. I am at a
loss as to the best way to proceed. Personally I would like to see this
change go upstream and then let the rest of the world figure out how to best
merge things.

The list of needed changes based on recent comments I am aware of are:
 - put back in a couple of header files per Andrew
 - fix the summary phrases to conform to coding standards per Andrew
 - add signed off by for Joakim to patch 04/10 per Joakim
 - fix bug in patch 06/10 noted in my email by passing bits as a parameter
to crc32_body

If anyone wants additional changes please let me know and I can put out a
clean version.


