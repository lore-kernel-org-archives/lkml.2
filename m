Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2CIRak (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 12:30:40 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38848 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754544Ab2CIRaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 12:30:39 -0500
Date: Fri, 9 Mar 2012 18:30:32 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tshimizu818@gmail.com, jeffrey.t.kirsher@intel.com,
        lucas.demarchi@profusion.mobi, mirq-linux@rere.qmqm.pl,
        paul.gortmaker@windriver.com, jdmason@kudzu.us, john.stultz@linaro.org,
        arnd@arndb.de, khc@pm.waw.pl, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        joel.clark@intel.com, kok.howg.ewe@intel.com
Subject: Re: [PATCH RE-SUBMIT] net/pch_gbe: supports eg20t ptp clock
Message-ID: <20120309173032.GA5730@netboy.at.omicron.at>
References: <1331079669-22446-1-git-send-email-tshimizu818@gmail.com>
 <20120306.213453.700930266749202538.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120306.213453.700930266749202538.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 09:34:53PM -0500, David Miller wrote:
> 
> You still haven't submitted this properly.
> 
> First, you submitted the PCH_GBE driver changes before the EG20T
> PTP clock driver which it depends upon.

David, both this pair of patches and the second pair apply cleanly to
both Torvalds mainline and to net-next. So, what are you complaining
about here? I am still confused.

Thanks,

Richard

