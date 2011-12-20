Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab1LTFbX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:31:23 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:36257 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1LTFbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:31:18 -0500
Date: Tue, 20 Dec 2011 13:30:59 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org, axboe@kernel.dk,
        ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading
	for x86 crypto drivers
Message-ID: <20111220053059.GA3108@gondor.apana.org.au>
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com> <4EEFC7D2.70803@zytor.com> <20111220040829.GD5637@one.firstfloor.org> <4EF014FE.4050101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF014FE.4050101@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 08:54:22PM -0800, H. Peter Anvin wrote:
>
> What is really bad is that it doesn't tell you anywhere what it *is* using.

You can always check /proc/crypto to see what is currently
registered.  The system will always choose the one with the
highest priority out of those as the default.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
