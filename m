Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933397Ab2FGWq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 18:46:59 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:45390 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933294Ab2FGWq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 18:46:58 -0400
Date: Fri, 8 Jun 2012 00:37:52 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Denys Fedoryshchenko <denys@visp.net.lb>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Deadlock, L2TP over IP are not working, 3.4.1
Message-ID: <20120607223752.GA4475@electric-eye.fr.zoreil.com>
References: <7ed49f446365ac625437702d92946add@visp.net.lb> <20120607205356.GA2491@electric-eye.fr.zoreil.com> <1339104606.6001.4.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339104606.6001.4.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> :
[...]
> If LLTX is used, this means several cpus can execute this code at the
> same time.
> 
> You need percpu stats, or use atomic primitives.

Would adding percpu stats not be frown upon ?

As atomic will defeat the 64 bits stats on 32 bits, I should probably stick
to plain bh disabling lock.

-- 
Ueimor
