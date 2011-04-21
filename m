Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab1DUL4y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 07:56:54 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:59043 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1DUL4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 07:56:52 -0400
X-SENDER-IP: [85.230.169.19]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlVaAEcbsE1V5qkTPGdsb2JhbACJGpwuCwEBAQE3Mohwu1kOhWgEkjw
X-IronPort-AV: E=Sophos;i="4.64,251,1301868000"; 
   d="scan'208";a="183316046"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 21 Apr 2011 13:58:43 +0200
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Jiri Kosina <jkosina@suse.cz>,
        Richard Nauber <richard.nauber@googlemail.com>,
        PenMount <penmount.touch@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, PenMount <salt@salt.com.tw>
Subject: Re: [PATCH] HID: add support for PenMount dual-touch panel
Message-ID: <20110421115843.GA7837@polaris.bitmath.org>
References: <1303291155-3148-1-git-send-email-salt@salt.com.tw>
 <20110420094700.GA2258@polaris.bitmath.org>
 <BANLkTin7Q3fD3vg90qCk12MGaVEvLBe0Mg@mail.gmail.com>
 <20110420100759.GA2436@polaris.bitmath.org>
 <alpine.LNX.2.00.1104211115570.12035@pobox.suse.cz>
 <BANLkTinND+uw=JYS4WbwNLAX8P5SF1VGqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinND+uw=JYS4WbwNLAX8P5SF1VGqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Once you are done with testing the last_field_index change, it'd be great
> > if you could respin the patches so that the first one perfoms this change,
> > and the second one adds PenMount support on top of it.
> >
> > I'll then apply it. Thanks,
> 
> Hi Jiri,
> 
> I'll do that as soon as Henrik tells me it is working.

The 3M (0596:0502) and eGalax (0eef:720c) seem to work as expected.

Cheers,
Henrik
