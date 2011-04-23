Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752747Ab1DWIfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 04:35:39 -0400
Received: from outbound.icp-qv1-irony-out6.iinet.net.au ([203.59.1.109]:45822
	"EHLO outbound.icp-qv1-irony-out6.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752216Ab1DWIfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 04:35:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBACGOsk3LrQ63/2dsb2JhbAANr0K7O4V2BJJYg08
X-IronPort-AV: E=Sophos;i="4.64,258,1301846400"; 
   d="scan'208";a="234921697"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <BANLkTikDCmH-WX1u3e9c7gc2U9HJ88RBUQ@mail.gmail.com>
Date: Sat, 23 Apr 2011 18:35:34 +1000
Cc: Stijn Devriendt <highguy@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <4083C8C3-920B-4CE1-B393-D8BA0E7BFB13@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <BANLkTinrtoGhL3CXJZGWzf8+BwFSRsdk0w@mail.gmail.com> <BANLkTikDCmH-WX1u3e9c7gc2U9HJ88RBUQ@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22/04/2011, at 9:36 PM, Linus Walleij wrote:

> 2011/4/21 Stijn Devriendt <highguy@gmail.com>:
> 
> 
>> I'd also like to add (if not already mentioned by others) that in
>> general drivers that use GPIOs are unaware of their physical
>> connection on the board. Having this information
>> in device-tree or platform-data equivalent solves this.
> 
> Yes, this has been mentioned a few times, and a few times I have
> replied that there is not one word in the patch set that says anything
> about whether drivers or board code or whatever shall make use of
> the mechanism, it's just an interface...
> 
> I don't understand why this keeps popping up, have I written
> *anything* unclear about this?

You haven't, no!  Just that the use case for gpiolib was always to expose
gpio functionality to drivers/ in a generic way.  The fact that it's
now been picked up extensively throughout arch/ is a (very) happy
side-effect.

	--Ben.

