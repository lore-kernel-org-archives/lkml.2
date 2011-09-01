Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932481Ab1IAWYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:24:42 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39879
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932265Ab1IAWYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:24:40 -0400
Date: Thu, 1 Sep 2011 18:24:22 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Bob Pearson <rpearson@systemfabricworks.com>,
        "'Andreas Dilger'" <adilger.kernel@dilger.ca>,
        "'Herbert Xu'" <herbert@gondor.hengli.com.au>,
        "'Theodore Tso'" <tytso@mit.edu>,
        "'David Miller'" <davem@davemloft.net>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Mingming Cao'" <cmm@us.ibm.com>,
        "'linux-crypto'" <linux-crypto@vger.kernel.org>,
        "'linux-fsdevel'" <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH 3/3] crc32c: Implement a self-test for CRC32c
Message-ID: <20110901222422.GA5771@infradead.org>
References: <20110901003317.32645.16843.stgit@elm3c44.beaverton.ibm.com>
 <20110901003336.32645.32746.stgit@elm3c44.beaverton.ibm.com>
 <03ac01cc6869$9cd23b60$d676b220$@systemfabricworks.com>
 <20110901221854.GA12086@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110901221854.GA12086@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 01, 2011 at 03:18:54PM -0700, Darrick J. Wong wrote:
> I suspect it would be pretty easy to adapt the Makefile to generate the
> relevant .c and .h files; in particular it could be useful to use the crypto
> framework for crc32 on the off chance anyone wants to provide hwaccel for that
> too.

crc32 or crc32c?  Note that there already is a hardware optimized crc32c
for recent Intel CPUs in arch/x86/crypto/crc32c-intel.c.

