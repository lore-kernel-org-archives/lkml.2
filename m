Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab1HVQKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:10:25 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57223 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752538Ab1HVQKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:10:23 -0400
Date: Mon, 22 Aug 2011 09:10:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Aug 22 (drivers/power/pda_power.c)
Message-Id: <20110822091020.a2f179c6.rdunlap@xenotime.net>
In-Reply-To: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
References: <20110822145304.980529cb921e5f1321c622da@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 14:53:04 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> [The kernel.org mirroring is a bit low today]


When CONFIG_USB_OTG_UTILS is not enabled:

drivers/power/pda_power.c: In function 'pda_power_probe':
drivers/power/pda_power.c:322: error: 'otg_is_usb_online' undeclared (first use in this function)
drivers/power/pda_power.c:322: error: (Each undeclared identifier is reported only once
drivers/power/pda_power.c:322: error: for each function it appears in.)
drivers/power/pda_power.c:325: error: 'otg_is_ac_online' undeclared (first use in this function)
drivers/power/pda_power.c:371: error: 'otg_handle_notification' undeclared (first use in this function)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
