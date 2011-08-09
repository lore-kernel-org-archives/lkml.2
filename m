Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1HIVHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 17:07:20 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:42509 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751149Ab1HIVHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 17:07:18 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=NOUpRjHmWIwA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=YD9nCfdJD6_Y5wMPJDoA:9 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: <akpm@linux-foundation.org>, <fzago@systemfabricworks.com>,
        <linux@horizon.com>, <linux-kernel@vger.kernel.org>
References: <4E40C4DD.90109@systemfabricworks.com> <OF7D1699A1.9B1BD547-ONC12578E7.005DB5FE-C12578E7.005E4AEB@transmode.se>
In-Reply-To: <OF7D1699A1.9B1BD547-ONC12578E7.005DB5FE-C12578E7.005E4AEB@transmode.se>
Subject: RE: [patch v3 5/7] crc32: add-real-8-bit.diff
Date: Tue, 9 Aug 2011 16:07:15 -0500
Message-ID: <018c01cc56d8$52131a10$f6394e30$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJBbQn92iQrRcakv6tV67w/vyzgZwMW3hdklBIfVnA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > -static uint32_t crc32table_le[4][LE_TABLE_SIZE];
> > -static uint32_t crc32table_be[4][BE_TABLE_SIZE];
> > +static uint32_t crc32table_le[8][256];
> > +static uint32_t crc32table_be[8][256];
> 
> Above is wrong as only 32 bits is supported at this point.

fixed.


