Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966519Ab0GSTet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 15:34:49 -0400
Received: from n77.bullet.mail.sp1.yahoo.com ([98.136.44.45]:32524 "HELO
	n77.bullet.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965813Ab0GSTer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 15:34:47 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 69497.95313.bm@omp202.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=n0gHg/DYGp8D2a1mL6DRBMWowlJJRF0bYJ9OALkxA0e33FeJiv1oS+Pr8I+9byTBUuO+XNzhWmuek6zaaeUE4AZUDgMS07z8+3qo4X+WfYnMtext02Hz5qe9KEmGWoE0rfOrTQ7YT2JOLeNTr6XoVxw00vCrbRj8/6cEqqEhcAE=;
Message-ID: <855202.18898.qm@web180313.mail.gq1.yahoo.com>
X-YMail-OSG: SUQiCLEVM1kOQrW51gB7jMJCKt6tE81YmxbS6AwOQVB78DM
 N91zYPnNpS.02gfP2J2aOJQgArL03xSAHw_nQDV0ME6mExPqA4pGH2aAt.9A
 LGNwuYPip5Jhskw5M6UhB6NtQGeVCJd9nX0_QEBb3ADv2TvOPms6ScztM8Z4
 rB4IvYINgqeWQt9nLgdSjnMIqpaK2YxaIXT5U2Msu3U9_tcTCmI39.PknoU8
 8wlzFI7S0SFW5P2WcOGKjsMLbQziMiBewiQ4PAnboOZkLCvd94OLIYUyaUYr
 gRud6xhb8c3At0IxmtQ--
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Mon, 19 Jul 2010 12:34:46 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [patch] usbnet: fix 100% CPU use on suspended device
To: dbrownell@users.sourceforge.net, Elly Jones <ellyjones@google.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <AANLkTimoosNfYOG4FSJYvlOVpEFpukF9dwxBbXA8k6yc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> This patch causes the usbnet module not to 
> attempt to submit URBs to the device
> if the device is not ready to accept them.

Looks plausible to me; can't test it or review
the underlying bug though.

> This fixes a
> misbehavior trigged by
> the Qualcomm Gobi driver (released under GPL through their Code Aurora initiative)

Which appears to be short on testing... :(

- Dave


