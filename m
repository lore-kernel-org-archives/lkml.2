Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab0FBKVF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 06:21:05 -0400
Received: from ringil.hengli.com.au ([216.59.3.182]:34038 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932296Ab0FBKVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 06:21:03 -0400
Date: Wed, 2 Jun 2010 20:20:58 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Andi Kleen <ak@linux.intel.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
       device-mapper development <dm-devel@redhat.com>,
       linux-kernel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
Message-ID: <20100602102058.GA18863@gondor.apana.org.au>
References: <20100531160425.GA20344@basil.fritz.box> <Pine.LNX.4.64.1005312239520.6372@hs20-bc2-1.build.redhat.com> <4C04AB6E.1080305@linux.intel.com> <Pine.LNX.4.64.1006020110220.22695@hs20-bc2-1.build.redhat.com> <4C060DEB.9020507@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C060DEB.9020507@linux.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 09:53:15AM +0200, Andi Kleen wrote:
>
> Behind disk??
>
> You're not serious?

Well my $20 wireless router can't perform AES and keep up with
the disk, but then it doesn't have two CPUs either :)

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
