Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759864Ab1KWIDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 03:03:23 -0500
Received: from mail-dy0-f46.google.com ([209.85.220.46]:52282 "EHLO
	mail-dy0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395Ab1KWIDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 03:03:21 -0500
Message-ID: <1322035395.1298.50.camel@edumazet-laptop>
Subject: Re: [3.1-rc8 REGRESSION] sky2 hangs machine on turning off or
 suspending
From: Eric Dumazet <eric.dumazet@gmail.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Wed, 23 Nov 2011 09:03:15 +0100
In-Reply-To: <CACna6rwDjqwypAr_03NEA=x8J_2DpL2LjgSMiQmLHHGv3AA7GA@mail.gmail.com>
References: <CACna6ryTdLcWVYgHu=_mRFga1sFivpE_DyZOY-HMmKggkWAJAw@mail.gmail.com>
	 <CACna6rwDjqwypAr_03NEA=x8J_2DpL2LjgSMiQmLHHGv3AA7GA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 23 novembre 2011 à 08:43 +0100, Rafał Miłecki a écrit :

> The bug was resolved by:
> sky2: fix hang in napi_disable
> 
> Stephen, two comments to you:
> 
> 1) I really hoped to get some info about resolving this issue. You
> could just ping me that something worth testing was posted.
> 

I agree 100%, I am verry sorry this happened.

Stephen, we must show toal respect to bug reporters, they do their part
of the job.

We need more bug reports :)

A "Reported-by:" tag is mandatory, not counting a CC on mails

As Rafal spent incredible time to bisect the bug, another tag is welcome
as well :

"Bisected-by:" ...

This takes maybe 20 seconds, while the bug fix took far more...

> 2) Update your e-mail address in MAINTAINERS please.
> 

What do you mean, it seems OK to me (Stephen Hemminger
<shemminger@vyatta.com>) ?



