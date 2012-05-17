Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520Ab2EQWiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 18:38:50 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:53784 "EHLO violet"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S967208Ab2EQWit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 18:38:49 -0400
Date: Fri, 18 May 2012 00:28:43 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Joe Perches <joe@perches.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joel Soete <soete.joel@scarlet.be>
Subject: Re: [RFC PATCH net-next] hp100: delete VG/AnyLAN hp100
Message-ID: <20120517222843.GA30680@electric-eye.fr.zoreil.com>
References: <1337272841-25931-1-git-send-email-paul.gortmaker@windriver.com> <1337272841-25931-3-git-send-email-paul.gortmaker@windriver.com> <4FB52C99.6010303@windriver.com> <20120517212039.GC27789@windriver.com> <1337292547.8872.20.camel@joe2Laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337292547.8872.20.camel@joe2Laptop>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> :
> On Thu, 2012-05-17 at 17:20 -0400, Paul Gortmaker wrote:
> > [Re: [PATCH 2/5] drivers/net: delete all code/drivers depending on CONFIG_MCA
> 
> If we're removing really old and unused stuff,
> how about the VG/AnyLAN driver too?

Joel Soete appeared to actively use a PCI one with recent kernels back
in 2007.

-- 
Ueimor
