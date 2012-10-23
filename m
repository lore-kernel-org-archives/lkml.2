Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2JWO5s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:57:48 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:61507 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932821Ab2JWO5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:57:47 -0400
Date: Tue, 23 Oct 2012 15:57:37 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kukjin Kim <kgene@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>
Subject: Re: ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined
Message-ID: <20121023145737.GB2823@mudshark.cambridge.arm.com>
References: <022101cdb12d$724e9650$56ebc2f0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <022101cdb12d$724e9650$56ebc2f0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 03:48:21PM +0100, Kukjin Kim wrote:
> Hi all,
> 
> Now, v3.7-rc2 happens following build error with s3c2410_defconfig...
> 
> ERROR: "read_current_timer" [fs/ext4/ext4.ko] undefined!
> make[2]: *** [__modpost] Error 1
> make[1]: *** [modules] Error 2
> make[1]: *** Waiting for unfinished jobs....
> 
> Any idea on this?

A fix for this is queued in rmk's fixes branch.

Will
