Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab1DTJWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:22:53 -0400
Received: from linux-sh.org ([111.68.239.195]:39514 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752507Ab1DTJWw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:22:52 -0400
Date: Wed, 20 Apr 2011 18:22:35 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: linux-next: build failure after merge of the final tree (fbdev tree related)
Message-ID: <20110420092235.GB15898@linux-sh.org>
References: <20110420141158.008d61b2.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110420141158.008d61b2.sfr@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 02:11:58PM +1000, Stephen Rothwell wrote:
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> drivers/video/s3fb.c: In function 's3_pci_remove':
> drivers/video/s3fb.c:1388: error: 'par' undeclared (first use in this function)
> 
> Caused by commit 86c0f043a737 ("s3fb: add DDC support").  Clearly not
> tested with CONFIG_MTRR not set :-(
> 
> I have reverted that commit for today.

I thought I had MTRR off in my test build, but it seems not.

Fixed now, thanks for the report!
