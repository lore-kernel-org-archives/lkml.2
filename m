Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220Ab2CFJZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 04:25:58 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59887 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab2CFJZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 04:25:55 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of richardcochran@gmail.com designates 10.14.28.4 as permitted sender) smtp.mail=richardcochran@gmail.com; dkim=pass header.i=richardcochran@gmail.com
Date: Tue, 6 Mar 2012 10:25:43 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tshimizu818@gmail.com, jeffrey.t.kirsher@intel.com,
        lucas.demarchi@profusion.mobi, mirq-linux@rere.qmqm.pl,
        paul.gortmaker@windriver.com, toshiharu-linux@dsn.okisemi.com,
        jdmason@kudzu.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH] net/pch_gbe: supports eg20t ptp clock
Message-ID: <20120306092542.GA28585@localhost.localdomain>
References: <1330926377-11531-1-git-send-email-tshimizu818@gmail.com>
 <20120305.005709.1597475617000728984.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305.005709.1597475617000728984.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:57:09AM -0500, David Miller wrote:
> 
> So how the heck is this supposed to work?
> 
> You post a patch for the e20tp clock source, you don't CC: netdev.
> 
> Then you post this network driver patch which depends upon that on
> and you do CC: netdev.
> 
> You've made it impossible for me to apply them both properly into my
> tree so that the dependency goes in.

I'm confused. Are you talking about a patch from last August?

In any case, if there two patches, then they should of course appear
together.

Thanks,
Richard
