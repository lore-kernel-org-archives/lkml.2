Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1GFR2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 13:28:45 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:39458 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996Ab1GFR2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 13:28:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKSZFE5tg3wf/2dsb2JhbABTqAR4iHoCu1cOhikEmlqIJg
Date: Wed, 6 Jul 2011 19:28:41 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Vitaly Kuzmichev <vkuzmichev@mvista.com>,
        linux-watchdog@vger.kernel.org, Nicolas Pitre <nico@fluxnic.net>,
        Marc Zyngier <marc.zyngier@arm.com>, John Stultz <johnstul@us.ibm.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V2 3/6] mpcore_wdt: Fix WDIOC_SETOPTIONS handling
Message-ID: <20110706172841.GM29245@infomag.iguana.be>
References: <1286185540-19569-1-git-send-email-vkuzmichev@mvista.com> <20110706135219.GB8286@n2100.arm.linux.org.uk> <201107061619.27580.arnd@arndb.de> <201107061727.08359.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107061727.08359.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

> No, same thing here:
> 
> On Wednesday 06 July 2011, Mail Delivery System wrote:
> > This is the mail system at host ylaen.iguana.be.
> > 
> > I'm sorry to have to inform you that your message could not
> > be delivered to one or more recipients. It's attached below.
> > 

Should be fixed now. It was something DNS related on ylaen.iguana.be apparently.
I hope I didn't miss to much e-mail...

Kind regards,
Wim.

