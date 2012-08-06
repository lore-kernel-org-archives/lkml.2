Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2HFM6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 08:58:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35754 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754334Ab2HFM6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 08:58:16 -0400
Date: Mon, 6 Aug 2012 13:58:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Daniel Mack <zonque@gmail.com>
Subject: Re: linux-next: build failure after merge of the spi-mb tree
Message-ID: <20120806125814.GG16861@opensource.wolfsonmicro.com>
References: <20120806120301.cafca6614722b92d92600904@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120806120301.cafca6614722b92d92600904@canb.auug.org.au>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 12:03:01PM +1000, Stephen Rothwell wrote:
> Hi Mark,
> 
> After merging the spi-mb tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

I've dropped these patches.  Daniel, please fix and resubmit.
