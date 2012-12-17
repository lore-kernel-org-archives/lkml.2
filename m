Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759Ab2LQVLe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:11:34 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:17900
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750889Ab2LQVLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:11:32 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VPS-5(zz98dI103dK1432Izz1de0h1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h1155h)
X-WSS-ID: 0MF71J2-01-9K8-02
X-M-MSG: 
Date: Mon, 17 Dec 2012 15:11:24 -0600
From: Jacob Shin <jacob.shin@amd.com>
To: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Doug Thompson <dougthompson@xmission.com>,
        <linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
Message-ID: <20121217211124.GB3012@jshin-Toonie>
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355774221.13361.48.camel@joe-AO722>
 <20121217200535.GF31866@liondog.tnic>
 <1355775376.19706.1.camel@joe-AO722>
 <20121217202214.GG31866@liondog.tnic>
 <1355776475.19706.6.camel@joe-AO722>
 <20121217204011.GH31866@liondog.tnic>
 <20121217204317.GA32760@jshin-Toonie>
 <1355777940.19706.11.camel@joe-AO722>
 <20121217210802.GI31866@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20121217210802.GI31866@liondog.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 10:08:02PM +0100, Borislav Petkov wrote:
> On Mon, Dec 17, 2012 at 12:59:00PM -0800, Joe Perches wrote:
> > The new pr_emerg is effectively a termination of the
> > previous one.  There's no need for 2 consecutive uses
> > of pr_emerg(HW_ERR ...) here.
> 
> Actually, in decode_mc5_mce(), the second pr_emerg needs to stay like
> what it is now.
> 
> So Jacob, please leave those changes out, I'll sort them out later.

Okay, will do, I'll change fix it in my changes then. But I'll wait
for your feedback tomorrow, before sending out V2.

Thanks!

-Jacob

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

