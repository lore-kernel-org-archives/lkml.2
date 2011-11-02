Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab1KBUxm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:53:42 -0400
Received: from balrog.mythic-beasts.com ([93.93.130.6]:58666 "EHLO
	balrog.mythic-beasts.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1KBUxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:53:41 -0400
X-Greylist: delayed 2501 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Nov 2011 16:53:40 EDT
Date: Wed, 2 Nov 2011 20:09:13 +0000
From: Luis Henriques <henrix@camandro.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: linux-next: build failure after merge of the crypto-current tree
Message-ID: <20111102200900.GA3454@hades>
References: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101115851.2e37ac680db78bdba0661691@canb.auug.org.au>
X-BlackCat-Spam-Score: -13
X-Mythic-Debug: Threshold =  On = 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In gmane.linux.kernel, you wrote:
> --Signature=_Tue__1_Nov_2011_11_58_51_+1100_R__G+wW+4zIqxa7J
> Content-Type: text/plain; charset=US-ASCII
> Content-Disposition: inline
> Content-Transfer-Encoding: quoted-printable
>
> Hi Herbert,
>
> After merging the crypto-current tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

I'm not sure if this is related, but I am currently unable to build mainline
kernel when disabling CONFIG_NET.  This seems to be due to the patch serie:

http://news.gmane.org/gmane.linux.kernel.cryptoapi/cutoff=6228

For instance, commit 6ad414fe710d4fd3a8c8c6c2ad8fefcfcc207968 adds a dependency
over function nla_put(), which is only defined when CONFIG_NET is enabled.

Cheers,
--
Luis Henriques
