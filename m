Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab2LCURz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 15:17:55 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:60235 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab2LCURy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 15:17:54 -0500
Message-ID: <50BD08EA.3090306@free-electrons.com>
Date: Mon, 03 Dec 2012 21:17:46 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] clocksource: sunxi_timer: Add terminating entry for sunxi_timer_dt_ids
References: <1354460899.3241.2.camel@phoenix>
In-Reply-To: <1354460899.3241.2.camel@phoenix>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 02/12/2012 16:08, Axel Lin a écrit :
> The of_device_id table is supposed to be zero-terminated.

Applied, thanks

-- 
Maxime Ripard, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
