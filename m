Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab1HTRkW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 13:40:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45906 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751382Ab1HTRkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 13:40:20 -0400
Date: Sat, 20 Aug 2011 18:40:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: anish singh <anish198519851985@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        Kernel-newbies <kernelnewbies@nl.linux.org>,
        Jonathan Cameron <jic23@cam.ac.uk>, Dave Hylands <dhylands@gmail.com>
Subject: Re: Headset driver detection problem during bootup
Message-ID: <20110820174017.GA28142@opensource.wolfsonmicro.com>
References: <CAK7N6vrj8V+7EYLmd92qd+Mae2KZu8K6BVwnwda=3y2vrcDWRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7N6vrj8V+7EYLmd92qd+Mae2KZu8K6BVwnwda=3y2vrcDWRw@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 19, 2011 at 09:23:13PM +0900, anish singh wrote:

> Once the handler is called then we find out if the headset
> is there or not using gpio and then normal detection happens

> Is it the right way to detect the device during power-up?

> After the device is powered up and then if we insert headset
> then it is working fine by calling the interrupt handler and
> everything goes fine.

The standard soc-jack code should already be reading the state of the
GPIO as part of its startup.
