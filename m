Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab1DTKG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 06:06:27 -0400
Received: from smtprelay-b22.telenor.se ([195.54.99.213]:53063 "EHLO
	smtprelay-b22.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab1DTKGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 06:06:25 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AitUAOavrk1V5qkTPGdsb2JhbACJGZwiCwEBAQE3MohvvXUOhWMEki0
X-IronPort-AV: E=Sophos;i="4.64,245,1301868000"; 
   d="scan'208";a="182995474"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Wed, 20 Apr 2011 12:07:59 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Richard Nauber <richard.nauber@googlemail.com>,
        PenMount <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        PenMount <salt@salt.com.tw>
Subject: Re: [PATCH] HID: add support for PenMount dual-touch panel
Message-ID: <20110420100759.GA2436@polaris.bitmath.org>
References: <1303291155-3148-1-git-send-email-salt@salt.com.tw>
 <20110420094700.GA2258@polaris.bitmath.org>
 <BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Benjamin: Since field->index == 0 is in use, it seems the driver could
> > execute event emission wrongly under some circumstances (when
> > last_field_index == 0). Is that related to the reason for the quirk in
> > this patch?
> 
> In fact, I have a second patch just on top of this one. It has been
> tested by Ryan with PenMount devices.

Great, and good timing. :-)

> I was waiting for Penmount to be included first as it does not impact
> any other drivers.

I would prefer the opposite order, since it is cleaner and means one
less device to test for the major change.

> 
> I inline the code here, but my gmail client will destroy tabs (so I
> attached it too)....
> 
> Can you test it against 3M?

I will test it against 3M and egalax. Thanks!

Henrik
