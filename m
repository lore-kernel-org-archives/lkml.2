Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0IPMEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 08:04:06 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:42526 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462Ab0IPMEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 08:04:05 -0400
Subject: Re: [RFC] led-class: always implement blinking
From: Johannes Berg <johannes@sipsolutions.net>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
References: <1282296102.3785.28.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Sep 2010 14:04:02 +0200
Message-ID: <1284638642.3731.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 11:21 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Currently, blinking LEDs can be awkward because it is
> not guaranteed that all LEDs implement blinking. The
> trigger that wants it to blink then needs to implement
> its own timer solution. Rather than require that, make
> the core always implement LED "blinkability" with a
> timer implementation in the core. The timer trigger
> then becomes a very trivial one, and all code using
> LEDs can rely on them to be able to blink.

No comments mean it's good to go in?

johannes

