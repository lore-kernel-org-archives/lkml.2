Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab2BWJJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 04:09:16 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58289 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752265Ab2BWJJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 04:09:13 -0500
Subject: Re: [PATCH] x86, efi: Fix unaligned access and endian issues
From: Matt Fleming <matt@console-pimps.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20120223105444.f0585f65e18be0360f9bfdb9@canb.auug.org.au>
References: <1329919208-8700-1-git-send-email-matt@console-pimps.org>
	 <20120223093140.3f8ad47252f9f331d355ea57@canb.auug.org.au>
	 <1329951508.4759.14.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20120223105444.f0585f65e18be0360f9bfdb9@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Feb 2012 09:09:09 +0000
Message-ID: <1329988149.4759.17.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-23 at 10:54 +1100, Stephen Rothwell wrote:
> > Peter was talking about exporting unaligned.h for host tools so this
> > patch will probably go through another iteration anyway.
> 
> OK.  In that case, I will add this version to my fixes tree in linux-next
> just so that the allmodconfig builds work again.  I will remove it when
> it turns up (presumably in the tip tree).

OK, thanks.

> Just to be clear, it wasn't the unaligned accesses that were causing me a
> problem (PowerPC copes), it was the endian issues.

Right. I'll fix up the commit message to be a bit clearer.

-- 
Matt Fleming, Intel Open Source Technology Center

