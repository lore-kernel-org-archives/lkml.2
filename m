Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1BOXlu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 18:41:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57627 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188Ab1BOXlr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 18:41:47 -0500
Date: Tue, 15 Feb 2011 15:41:28 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Linus =?ISO-8859-1?B?TPxzc2luZw==?= <linus.luessing@web.de>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, bridge@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Multicast snooping fixes and suggestions
Message-ID: <20110215154128.2a28632c@nehalam>
In-Reply-To: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
References: <1297811961-19249-1-git-send-email-linus.luessing@web.de>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 00:19:16 +0100
Linus Lüssing <linus.luessing@web.de> wrote:

> Hello everyone,
> 
> While testing the (very awesome!) bridge igmp/mld snooping support I came across
> two issues which are breaking IPv6 multicast snooping and IPv6
> non-link-local multicast on bridges with multicast snooping support enabled
> in general. The first two patches shall fix these issues.
> 
> The third one addresses a potential bug on little endian machines which I noticed
> during this little code reviewing. This patch is untested though, feedback welcome.
> 
> The fourth and fifth patch are a suggestion to also permit using the bridge multicast
> snooping feature for link local multimedia multicast traffic. Therefore
> using the transient multicast flag instead of the non-link-local scope criteria
> seems to be a suitable solution at least for IPv6, in my opinion. Let me know what
> you think about it.
> 
> Thanks for reviewing these patches.
> 
> Cheers,
> Linus

These look correct. Did you test them with real traffic?
