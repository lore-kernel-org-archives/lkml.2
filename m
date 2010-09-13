Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0IMVLM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:11:12 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:47762 "EHLO
	emergent.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754359Ab0IMVLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:11:11 -0400
Date: Mon, 13 Sep 2010 17:11:06 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Joe Perches <joe@perches.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH 18/25] drivers/serial/suncore.c: Use static const char
 arrays
Message-ID: <20100913211106.GA4200@elliptictech.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
References: <cover.1284406638.git.joe@perches.com>
 <0ab674aa32a5fcc364982c78efdf44864a61523b.1284406639.git.joe@perches.com>
 <20100913213613.223e10a5@lxorguk.ukuu.org.uk>
 <1284409338.26719.47.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284409338.26719.47.camel@Joe-Laptop>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-13 13:22 -0700, Joe Perches wrote:
> It tries to standardize the style use and it avoids possible
> future checkpatch warnings of:
> 	char foo[] = "bar"
> char array could possibly be static const.

Whoa, back up a second here.  I've seen patches to avoid questionable
checkpatch warnings before, but I think this is the first time I've seen
a patch to avoid *hypothetical checkpatch warnings that don't even
exist*!

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
