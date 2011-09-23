Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1IWJhM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 05:37:12 -0400
Received: from nef2.ens.fr ([129.199.96.40]:4046 "EHLO nef2.ens.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab1IWJhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 05:37:09 -0400
Date: Fri, 23 Sep 2011 11:37:04 +0200
From: =?iso-8859-1?Q?=C9ric?= Brunet <Eric.Brunet@lps.ens.fr>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Regression between 2.6.35 and 2.6.38 (freeze at resume)
Message-ID: <20110923093704.GB8971@lps.ens.fr>
References: <201109170935.17777.Eric.Brunet@lps.ens.fr>
 <201109202206.35705.Eric.Brunet@lps.ens.fr>
 <s5hy5xigjts.wl%tiwai@suse.de>
 <20110921200939.5898164EE5@quatramaran.ens.fr>
 <s5hfwjpp2es.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hfwjpp2es.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.1.4 (nef2.ens.fr [129.199.96.32]); Fri, 23 Sep 2011 11:37:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dans son message du jeudi 22/09/11 à  7:32, Takashi Iwai a écrit:
> 
> As mentioned, the series of patches were added first in 3.1-rc.
> 3.0.x have no these commits.
> 
3.1-rc6 crashed on me this morning at resume time. Unfortunately, nothing
appeared in the logs so I cannot be 100% sure it is the same bug as has
been hitting me since circa 2.6.38, but it looks the same.

What should I do now ? Run 3.1-rc7 and hope for the best ? Go on with
3.1-rc6 and hope that I'll get a crash with information in the logs so as
to make sure it is indeed the same bug ? Or go back to 2.6.38 to try to
pinpoint the first problematic kernel and (hopefully) the change that
introduced the problem ?

Thanks,

	Éric Brunet
