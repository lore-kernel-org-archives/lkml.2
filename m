Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab2BHWg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 17:36:26 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab2BHWgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 17:36:25 -0500
Date: Wed, 8 Feb 2012 14:36:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Austin Boyle <Austin.Boyle@Aviatnet.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, <rtc-linux@googlegroups.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] rtc: ds1307: generalise ram size and offset
Message-Id: <20120208143624.592303f5.akpm@linux-foundation.org>
In-Reply-To: <1328739796.3117.77.camel@pc786-ubu.gnet.global.vpn>
References: <1326144071.3096.25.camel@pc786-ubu.gnet.global.vpn>
	<20120111110650.GC2605@pengutronix.de>
	<1326320516.3096.64.camel@pc786-ubu.gnet.global.vpn>
	<20120119194541.GA32483@pengutronix.de>
	<1328143057.3159.34.camel@pc786-ubu.gnet.global.vpn>
	<1328221704.3159.50.camel@pc786-ubu.gnet.global.vpn>
	<20120207145652.GH2539@pengutronix.de>
	<1328739796.3117.77.camel@pc786-ubu.gnet.global.vpn>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Feb 2012 11:23:16 +1300
Austin Boyle <Austin.Boyle@Aviatnet.com> wrote:

> this patch is based on Wolfram Sang's tree:
> git://git.pengutronix.de/git/wsa/linux-2.6.git ds1307

Wolfram, that tree appears not to be in linux-next?  If so, please
let's get it in there.

Meanwhile I dropped the old version of this patch and won't (can't)
apply v4.

