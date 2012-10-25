Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab2JYMmO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:42:14 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:44027 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347Ab2JYMmK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:42:10 -0400
Message-ID: <5089339B.4040502@mev.co.uk>
Date: Thu, 25 Oct 2012 13:42:03 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: linux-next: manual merge of the staging tree with the staging.current
 tree
References: <20121025131907.cab4682e1792998d9cca2c19@canb.auug.org.au>
In-Reply-To: <20121025131907.cab4682e1792998d9cca2c19@canb.auug.org.au>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-10-25 03:19, Stephen Rothwell wrote:
> Hi Greg,
>
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/comedi/drivers/amplc_dio200.c between commit dfb2540e91e1
> ("staging: comedi: amplc_dio200: fix possible NULL deref during detach")
> from the staging.current tree and commit 71b3e9e8dc21 ("staging: comedi:
> amplc_dio200: support memory-mapped I/O") from the staging tree.
>
> I fixed it up (the latter is a superset of the former) and can carry the
> fix as necessary (no action is required).

Sorry, I remember editing that while rebasing my patches.  I think I 
must have assumed the NULL deref patch had already been applied to 
Greg's "staging-next" branch, but it had in fact it had only been 
applied to his "staging-linus" branch.  I was editing various other bits 
while rebasing that patch series, so I never noticed that particular 
edit as being a conflict.

Apologies for the inconvenience it caused you.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
