Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0IBCq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 22:46:26 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62821 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297Ab0IBCqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 22:46:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=L8Zev4Y2N+GE7JaEz2xpV2xapvSvd/YvQS82Nv0VBzFvqANf1hpEmyAm1stCyL9QmB
         mqv0e+eQIz/VQ5aURE92iAQ40H812587U41Nt9ss+REAZHAxDsuEMZGVa0x9KRVfzG2e
         FxlRargLnfk7JrpFYwcGZacIgojukCFvTlcqc=
Date: Wed, 1 Sep 2010 19:46:17 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kevin Wells <wellsk40@gmail.com>
Subject: Re: linux-next: manual merge of the input tree with the
 input-current tree
Message-ID: <20100902024617.GA9303@core.coreip.homeip.net>
References: <20100902115958.982d7618.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902115958.982d7618.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 11:59:58AM +1000, Stephen Rothwell wrote:
> Hi Dmitry,
> 
> Today's linux-next merge of the input tree got a conflict in
> drivers/input/touchscreen/Makefile between commit
> 948e90e22f01287302d84b5b8d4ba330a41dbf8a ("Input: mrst-touchscreen - move
> out of staging") from the input-current tree and commit
> 3045a5f5202a1e0ab6ba2bf90a786cf4cae6932a ("Input: add LPC32xx touchscreen
> controller driver") from the input tree.
> 
> Just overlapping additions.  I fixed it up (see below) and can carry the
> fix for a while.

Doh! I did not mean to put mrst changes into 'for-linus'. It is too late
to re-fetch, isn't it?

-- 
Dmitry
