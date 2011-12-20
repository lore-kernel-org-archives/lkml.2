Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1LTFiq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 00:38:46 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:48794 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1LTFij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 00:38:39 -0500
Date: Tue, 20 Dec 2011 13:38:26 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>,
        linux-kernel@vger.kernel.org, trenn@suse.de, kay.sievers@vrf.org,
        Andi Kleen <ak@linux.intel.com>, kay.sievers@vrfy.org, axboe@kernel.dk,
        ying.huang@intel.com
Subject: Re: [PATCH 03/10] crypto: Add support for x86 cpuid auto loading
	for x86 crypto drivers
Message-ID: <20111220053826.GA3184@gondor.apana.org.au>
References: <1324334865-30459-1-git-send-email-andi@firstfloor.org> <1324334865-30459-4-git-send-email-andi@firstfloor.org> <20111219232246.GB570@redhat.com> <4EEFC7D2.70803@zytor.com> <20111220040829.GD5637@one.firstfloor.org> <4EF014FE.4050101@zytor.com> <20111220053059.GA3108@gondor.apana.org.au> <4EF01E89.5000007@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EF01E89.5000007@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 09:35:05PM -0800, H. Peter Anvin wrote:
> On 12/19/2011 09:30 PM, Herbert Xu wrote:
> > On Mon, Dec 19, 2011 at 08:54:22PM -0800, H. Peter Anvin wrote:
> >>
> >> What is really bad is that it doesn't tell you anywhere what it *is* using.
> > 
> > You can always check /proc/crypto to see what is currently
> > registered.  The system will always choose the one with the
> > highest priority out of those as the default.
> 
> Yes, but it's ridiculous for it to list all the things I'm *not* using,
> but not what I *am* using...

If your system doesn't have the VIA Padlock it won't even show
up in /proc/crypto since it'll fail to register.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
