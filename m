Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1IABVA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:21:00 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:49452 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756900Ab1IABU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:20:57 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=QcSFu2tMqX8VyBnwf4xZriMeG3TVj1s8v1Rcea0EwGI= c=1 sm=0 a=i3nTHVxZCpQA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=r17jK6sfZkYSxad0qIwqKg==:17 a=FNyBlpCuAAAA:8 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=krsQxP4RaMXavIbb3LoA:9 a=CjuIK1q_8ugA:10 a=r17jK6sfZkYSxad0qIwqKg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 24.153.165.185
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'Darrick J. Wong'" <djwong@us.ibm.com>
Cc: "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'David Miller'" <davem@davemloft.net>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        <linux-ext4@vger.kernel.org>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com> <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com> <20110901010737.GA25658@gondor.apana.org.au>
In-Reply-To: <20110901010737.GA25658@gondor.apana.org.au>
Subject: RE: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Date: Wed, 31 Aug 2011 20:20:55 -0500
Message-ID: <035501cc6845$66a0ad20$33e20760$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQJddRUsX2yw9FHRjYSS+DL11RlRewG0UjMaAwzbIUuT75cb8A==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you elaborate a little on this?

> -----Original Message-----
> From: Herbert Xu [mailto:herbert@gondor.apana.org.au]
> Sent: Wednesday, August 31, 2011 8:08 PM
> To: Darrick J. Wong
> Cc: Andreas Dilger; Theodore Tso; David Miller; Bob Pearson; linux-kernel;
> Mingming Cao; linux-crypto; linux-fsdevel; linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
> 
> On Wed, Aug 31, 2011 at 05:33:36PM -0700, Darrick J. Wong wrote:
> > This is a loadable module that will self-test the CRC32c code.
> >
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> 
> Please use the existing crypto testing framework.
> 
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

