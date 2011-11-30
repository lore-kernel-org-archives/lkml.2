Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab1K3Wcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 17:32:47 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:37671 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab1K3Wcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 17:32:46 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18UrqXQEZjEYDK4g7j7yFu/
Date: Wed, 30 Nov 2011 14:32:42 -0800
From: Tony Lindgren <tony@atomide.com>
To: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Cc: Paul Walmsley <paul@pwsan.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2a/5] Remove unsafe clock values from omap1_defconfig
Message-ID: <20111130223242.GS31337@atomide.com>
References: <20111128174508.GO31337@atomide.com>
 <1322517644-5066-1-git-send-email-jkrzyszt@tis.icnet.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322517644-5066-1-git-send-email-jkrzyszt@tis.icnet.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Janusz Krzysztofik <jkrzyszt@tis.icnet.pl> [111128 13:26]:
>
> I'm not sure which of the patches you meant not ready for 3.2-rc. From
> your comment I would conclude that only patch 3/5, which would really
> break omap1_defconfig booting on some boards, is questionable, while you
> posted this comment against patch 1/5, which I don't see how it could
> break booting, including omap1_defconfig.

Sorry for the delay in replying, yes you're right looks like it's allowing
the rate changes currently that would break things in 3/5.
 
> Anyway, I hope that the additional patch below is addressing all your
> concerns.

I'd rather not modify omap1_defconfig as a fix assuming that we'll be
removing all those options anyways the next merge window together with
your new patch.
 
Can you please split your series into two: Fix(es) for the -rc cycle,
then patches that can be left for the next merge window.

Cheers,

Tony
