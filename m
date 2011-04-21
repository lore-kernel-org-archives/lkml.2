Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1DUJRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 05:17:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400Ab1DUJRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 05:17:07 -0400
Date: Thu, 21 Apr 2011 11:17:04 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Richard Nauber <richard.nauber@googlemail.com>,
        PenMount <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, PenMount <salt@salt.com.tw>
Subject: Re: [PATCH] HID: add support for PenMount dual-touch panel
In-Reply-To: <20110420100759.GA2436@polaris.bitmath.org>
Message-ID: <alpine.LNX.2.00.1104211115570.12035@pobox.suse.cz>
References: <1303291155-3148-1-git-send-email-salt@salt.com.tw> <20110420094700.GA2258@polaris.bitmath.org> <BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com> <20110420100759.GA2436@polaris.bitmath.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Apr 2011, Henrik Rydberg wrote:

> > In fact, I have a second patch just on top of this one. It has been
> > tested by Ryan with PenMount devices.
> 
> Great, and good timing. :-)
> 
> > I was waiting for Penmount to be included first as it does not impact
> > any other drivers.
> 
> I would prefer the opposite order, since it is cleaner and means one
> less device to test for the major change.

I agree with Henrik on this.

Once you are done with testing the last_field_index change, it'd be great 
if you could respin the patches so that the first one perfoms this change, 
and the second one adds PenMount support on top of it.

I'll then apply it. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
