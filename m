Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab1IAFkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 01:40:14 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:34311 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab1IAFkL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 01:40:11 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=i3nTHVxZCpQA:10 a=ozIaqLvjkoIA:10 a=IkcTkHD0fZMA:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=pWYDmshDNZ9tJbmrvWEA:9 a=QEXdDO2ut3YA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Darrick J. Wong'" <djwong@us.ibm.com>,
        "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'David Miller'" <davem@davemloft.net>
Cc: "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
In-Reply-To: <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
Subject: RE: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Thu, 1 Sep 2011 00:40:08 -0500
Message-ID: <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJddRUsX2yw9FHRjYSS+DL11RlRewG0UjMalAhDrzA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darrick,

The same code in crc32.c was helpful to measure performance and help code tuning as well as indicate correctness. Otherwise the code in crypto may be enough to test all the corner cases. If this survives the review I wonder if there is a way to combine crc32 and crc32c together somehow. I like yours because you can load/unload and not need the memory permanently.

Bob

