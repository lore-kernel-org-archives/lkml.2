Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524Ab1K2LZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:25:29 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:46385 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473Ab1K2LZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:25:26 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPu/1E5R8sT5/2dsb2JhbABDqnSBBoFyAQEEATocIwULCANGFA0YAyETiAUCtyASiwwElFOJDYFQhzY
Date: Tue, 29 Nov 2011 12:21:57 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nicolas Thill <nico@openwrt.org>,
        Heiko Ronsdorf <hero@ihg.uni-duisburg.de>,
        Rodolfo Giometti <giometti@ascensit.com>,
        Andrey Panin <pazke@donpac.ru>, Guido Guenther <agx@sigxcpu.org>,
        Curt E Bruns <curt.e.bruns@intel.com>,
        Deepak Saxena <dsaxena@plexity.net>,
        Andrew Victor <linux@maxim.org.za>,
        "George G. Davis" <gdavis@mvista.com>,
        Sylver Bruneau <sylver.bruneau@googlemail.com>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 1/2 (resend)] watchdog: Use DEFINE_SPINLOCK() for
	static spinlocks
Message-ID: <20111129112157.GJ23376@infomag.iguana.be>
References: <1322546041.9040.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322546041.9040.1.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alex,

> Rather than just defining static spinlock_t variables and then
> initializing them later in init functions, simply define them with
> DEFINE_SPINLOCK() and remove the calls to spin_lock_init().
> 
> Cc: Wim Van Sebroeck <wim@iguana.be>
> Cc: Nicolas Thill <nico@openwrt.org>
> Cc: Heiko Ronsdorf <hero@ihg.uni-duisburg.de>
> Cc: Rodolfo Giometti <giometti@ascensit.com>
> Cc: Andrey Panin <pazke@donpac.ru>
> Cc: Guido Guenther <agx@sigxcpu.org>
> Cc: Curt E Bruns <curt.e.bruns@intel.com>
> Cc: Deepak Saxena <dsaxena@plexity.net>
> Cc: Andrew Victor <linux@maxim.org.za>
> Cc: George G. Davis <gdavis@mvista.com>
> Cc: Sylver Bruneau <sylver.bruneau@googlemail.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Added to the linux-next branch of the watchdog tree.

Kind regards,
Wim.

