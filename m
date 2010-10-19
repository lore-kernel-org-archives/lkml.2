Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495Ab0JSAHw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:07:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38299 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751896Ab0JSAHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:07:50 -0400
Date: Mon, 18 Oct 2010 17:07:31 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Hsiang <Peter.Hsiang@maxim-ic.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
Message-ID: <20101019000730.GA27248@opensource.wolfsonmicro.com>
References: <20101018142934.65f5d0fa.sfr@canb.auug.org.au>
 <B2150E1E4418E1438554A300EA5040E40D47140D97@ITSVLEX06.it.maxim-ic.internal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B2150E1E4418E1438554A300EA5040E40D47140D97@ITSVLEX06.it.maxim-ic.internal>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:25:12PM -0700, Peter Hsiang wrote:

> This message seems to be saying that this header file is missing.
> However, this header file was included in the patch that was submitted,
> and it did compile fine here before the submit.
> I don't understand why it's not there after it was applied?

Your patch was apparently not generated against the mainline Makefile or
Kconfig and the automated conflict resolution tool I used (which is
normally fairly reliable) appears to have misplaced the header.  I've
restored the driver with the readdition of the header.
