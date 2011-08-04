Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab1HDSHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 14:07:49 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:5215 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753869Ab1HDSHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 14:07:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAIbdOk5R8j0b/2dsb2JhbABDp2d4gUABAQQBOhwjBQsIA0YUJQMhE4dsAsE2DoY0BJsuiDM
Date: Thu, 4 Aug 2011 20:07:39 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: WatchDog Timer Driver Core - use passed
	watchdog_device
Message-ID: <20110804180739.GT4227@infomag.iguana.be>
References: <201108031538.21137.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108031538.21137.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H Hartley,

> Use the passed watchdog_device instead of the static global variable when
> testing and setting the status in watchdog_ping, watchdog_start, and
> watchdog_stop.  Note that the callers of these functions are actually
> passing the static global variable.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Wim Van Sebroeck <wim@iguana.be>

This will be added. We will need this when we go to the sysfs part of the core anyway.

Kind regards,
Wim.

