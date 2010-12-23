Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522Ab0LWRzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:55:46 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48354
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753322Ab0LWRzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:55:45 -0500
Date: Thu, 23 Dec 2010 09:56:15 -0800 (PST)
Message-Id: <20101223.095615.39194231.davem@davemloft.net>
To: jkosina@suse.cz
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vojtech@suse.cz,
        ilpo.jarvinen@helsinki.fi
Subject: Re: [PATCH] tcp: cleanup of cwnd initialization in
 tcp_init_metrics()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.LNX.2.00.1012231022430.16569@pobox.suse.cz>
References: <alpine.LNX.2.00.1012231002310.16569@pobox.suse.cz>
	<1293095663.7789.3.camel@edumazet-laptop>
	<alpine.LNX.2.00.1012231022430.16569@pobox.suse.cz>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>
Date: Thu, 23 Dec 2010 10:23:38 +0100 (CET)

> Right, that's even better. Updated patch below.
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: [PATCH] tcp: cleanup of cwnd initialization in tcp_init_metrics()
> 
> Commit 86bcebafc5e7f5 ("tcp: fix >2 iw selection") fixed a case
> when congestion window initialization has been mistakenly omitted
> by introducing cwnd label and putting backwards goto from the
> end of the function.
> 
> This makes the code unnecessarily tricky to read and understand
> on a first sight.
> 
> Shuffle the code around a little bit to make it more obvious.
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Applied, thanks everyone.
