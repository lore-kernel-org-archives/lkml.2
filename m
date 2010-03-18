Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab0CROl6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 10:41:58 -0400
Received: from are.twiddle.net ([75.149.56.221]:46438 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab0CROl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 10:41:57 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 10:41:57 EDT
Message-ID: <4BA23974.5030503@twiddle.net>
Date: Thu, 18 Mar 2010 07:32:20 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com>
In-Reply-To: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2010 07:01 PM, John Stultz wrote:
> Alpha has a tsc like rpcc counter that it uses to manage time.
> This can be converted to an actual clocksource instead of utilizing
> the arch_gettimeoffset method that is really only there for legacy
> systems with no continuous counter.

With 8 seconds or less between roll-overs, do you actually consider
this a continuous counter?  I don't.  I suggest this be left alone.


r~
