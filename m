Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494Ab2DPWfF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:35:05 -0400
Received: from foo.stuge.se ([212.116.89.98]:40652 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753021Ab2DPWfC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:35:02 -0400
Message-ID: <20120416223459.18769.qmail@stuge.se>
Date: Tue, 17 Apr 2012 00:34:59 +0200
From: Peter Stuge <peter@stuge.se>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [ath9k-devel] [ 00/78] 3.3.2-stable review
Mail-Followup-To: Felipe Contreras <felipe.contreras@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk
References: <20120413105746.10ffb120@stein> <CAMP44s0RohH9tPiM5qCDT57XBV=iO66PZkSjYVxA6Usg1qJPtw@mail.gmail.com> <20120413190819.9469.qmail@stuge.se> <CAMP44s02v_OhviaF12Y8LWBJygyVLZk00d3P69GVvKAeJwjiuw@mail.gmail.com> <20120416162710.GA24100@kroah.com> <CAMP44s1o9kBp8672oBnvna+qH4WpqSqGUsyNpc_C74cfNYcX_g@mail.gmail.com> <20120416205856.GA22298@kroah.com> <CAMP44s2OdH+1RG2O6+QXkik8Ww_ZSHN=yzEKwD1KvRAcceNSRA@mail.gmail.com> <20120416212718.GA22824@kroah.com> <CAMP44s2bg8AC+jMXRv-GoRaag2qDgttHoVWmKOxH7zTg4-qtLQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMP44s2bg8AC+jMXRv-GoRaag2qDgttHoVWmKOxH7zTg4-qtLQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras wrote:
> With more people using Arch Linux and thus the latest "stable"
> release, I'd say we might see an increase in these kinds of issues.

You touch on an important point. Arch has it's own support channels,
and after a few of these kinds of issues perhaps Arch will decide to
push a different kernel to their users.

None of the Arch users I know (though only a few) would have had a
critical problem without wifi.

What kernel to push to users is anyway a distribution problem, so if
you must discuss then please discuss within the Arch community the
pros and cons of the various available kernel trees. Maybe they will
prefer another one than they currently do, after your reasoning.

I personally don't care about what any distribution does; I just use
Linus' tree, and I might merge some other trees if they have
important changes which I want before Linus takes them. When I did
this the first time is btw the time where I really learned to
appreciate just how powerful git is.


//Peter
