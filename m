Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab1JKNFi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 09:05:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36736 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752285Ab1JKNFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 09:05:36 -0400
Date: Tue, 11 Oct 2011 14:05:34 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?B?IkhlaWtvIFN0/GJuZXIi?= <heiko@sntech.de>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: linux-next: build failure after merge of the moduleh tree
Message-ID: <20111011130534.GA3471@opensource.wolfsonmicro.com>
References: <20111011192515.1f69837816e4cebd1e097385@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011192515.1f69837816e4cebd1e097385@canb.auug.org.au>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 07:25:15PM +1100, Stephen Rothwell wrote:

> I have applied the following patch for today.  Mark, Liam, this should be
> applied to the regulator tree.

I open coded this since it was easier than fishing the patch out of the
backtrace.
