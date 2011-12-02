Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab1LBAY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:24:27 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:57648 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861Ab1LBAYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:24:25 -0500
Date: Fri, 2 Dec 2011 08:23:58 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Mingming Cao <cmm@us.ibm.com>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v5.2 00/14] crc32c: Add faster algorithm and self-test
	code
Message-ID: <20111202002358.GA19842@gondor.apana.org.au>
References: <20111201201341.5876.83743.stgit@elm3c44.beaverton.ibm.com> <20111201202053.GG1495@noexit.corp.google.com> <20111201203122.GC23175@tux1.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201203122.GC23175@tux1.beaverton.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 12:31:22PM -0800, Darrick J. Wong wrote:
.
> They seem to call crc32c(), which is in crypto/crc32c.  If you're interested in

Nope, the crypto API layer will use the SSE implementation
where available.  Only when it isn't available will the C version
in crypto/ be used.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
