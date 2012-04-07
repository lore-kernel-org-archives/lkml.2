Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab2DGPSr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2012 11:18:47 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61424 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753016Ab2DGPSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:18:46 -0400
Date: Sat, 7 Apr 2012 17:18:35 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Marc Kleine-Budde <mkl@blackshift.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] ARM: ixp4xx: fix compilation and oops
Message-ID: <20120407151834.GA18732@netboy.at.omicron.at>
References: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328729069-21308-1-git-send-email-mkl@blackshift.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 08:24:27PM +0100, Marc Kleine-Budde wrote:
> Hello,
> 
> this patch series targets current linus master (v3.3-rc2-230-gc2e50e3). It
> fixes compilation of several boards of the ARM ixp4xx architecture and
> a boot oops.
> 
> With these patches applied I my nslu boots fine.
> 
> Please consider to applpy this series to the upcoming v3.3 kernel.

I see patch #2 as a3c1e3b732b3708a80e4035b9d845f3f7c7dd0c9, but what
happened to the first patch?

Thanks,
Richard
