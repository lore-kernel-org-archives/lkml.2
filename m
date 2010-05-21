Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016Ab0EUQkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:40:51 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:49020 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758248Ab0EUQkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:40:49 -0400
Message-ID: <4BF6B673.1080507@euromail.se>
Date: Fri, 21 May 2010 18:36:03 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Ping Cheng <pinglinux@gmail.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mika Kuoppala <mika.kuoppala@nokia.com>,
       Peter Hutterer <peter.hutterer@who-t.net>,
       Benjamin Tissoires <tissoire@cena.fr>, Stephane Chatty <chatty@enac.fr>,
       Rafi Rubin <rafi@seas.upenn.edu>, Michael Poole <mdpoole@troilus.org>
Subject: Re: [PATCH 2/2] input: mt: Document the MT event slot protocol (rev3)
References: <1274457354-5570-1-git-send-email-rydberg@euromail.se>	 <1274457354-5570-2-git-send-email-rydberg@euromail.se> <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
In-Reply-To: <AANLkTikBWzgRmso0oQNXcTxeExdKZORXYbIwK9CcMl85@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OFVCg-0006W2-Br.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1OFVCg-0006W2-Br d65f42571ef0462cb85b5fc7c71012fc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Cheng wrote:
> Hi Henrik,
> 
> Thank you for your quick turnaround. Two minor comments in line.
> 
> Ping

Thanks for those, yes, both mistakes. Dmitry, in case you find these last
versions acceptable, perhaps one could change them manually:

1. Patch description: s/SYN_MT_SLOT/ABS_SLOT/
2. Test: s/hardware of computed/hardware or computed/

Thanks,
Henrik

