Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346Ab1BXGhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 01:37:47 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754161Ab1BXGhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 01:37:45 -0500
Date: Wed, 23 Feb 2011 22:37:37 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus =?ISO-8859-1?B?TPxz?= =?ISO-8859-1?B?c2luZw==?= 
	<linus.luessing@web.de>,
        "David S. Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Multicast snooping fixes and suggestions
Message-ID: <20110223223737.594932a8@nehalam>
In-Reply-To: <89132767-587d-4186-8eac-9692bed59a44@email.android.com>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
	<4D65CD81.4070203@zytor.com>
	<20110224040412.GA25488@gondor.apana.org.au>
	<4D65E2B4.1010501@zytor.com>
	<20110224054232.GA26064@gondor.apana.org.au>
	<89132767-587d-4186-8eac-9692bed59a44@email.android.com>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 21:57:32 -0800
"H. Peter Anvin" <hpa@zytor.com> wrote:

> Ok, so stupid question... how do hardware switches deal with this? It would seem to me that if everyone behind say a Cisco switch had these kind of issues they would have limited appeal...

Real bridges run current newwer Spanning Tree Protocol that converges faster.
The current Linux STP code is on older standard (around 2001). The current STP
standard use RSTP which converges much faster.
  http://en.wikipedia.org/wiki/Spanning_Tree_Protocol

There is a userspace RSTP daemon that almost nobody uses.

There are a number of other STP enhancements that are needed like
STP protection and MSTP, as welll as the Cisco non-standard STP VLAN stuff.

Fixing STP and testing it is a fairly project, too big for a spare time
effort and currently not something high enough on the project chart for me to
be able to dedicate much company time on. Contributions welcome.
