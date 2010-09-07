Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0IGXjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:39:08 -0400
Received: from 217.59.140-88.rev.gaoland.net ([88.140.59.217]:52479 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756557Ab0IGXjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:39:05 -0400
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 19:39:05 EDT
Date: Wed, 8 Sep 2010 01:29:57 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Matt Causey <matt.causey@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Simon Kagstrom <simon.kagstrom@netinsight.net>
Subject: Re: Is via-velocity broken in 2.6.34?
Message-ID: <20100907232957.GA11595@electric-eye.fr.zoreil.com>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: netdev@vger.kernel.org

Matt Causey <matt.causey@gmail.com> :
[2.6.29 -> 2.6.34 regression]
> Attached is debug.tar.  It contains dmesg, config.gz, ethtool,
> ifconfig, and lspci output.  I'm not sure what else to do at this
> point.  Is there some debugging I can enable in the kernel to give
> more clues as to what's gone wrong?

Any chance you could bisect the regression or narrow it down a bit ?

Otherwise may I assume that there is no difference in the
userspace tools (just in case) ?

-- 
Ueimor
