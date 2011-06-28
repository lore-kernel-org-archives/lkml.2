Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1F1IJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:09:26 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:17661 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754544Ab1F1IIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:08:54 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADaLCU5tg6TL/2dsb2JhbABSpzp4iHcCwnIOhiIEmheBMoZq
Date: Tue, 28 Jun 2011 10:08:52 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martyn Welch <martyn.welch@ge.com>,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] watchdog: gef_wdt: fix MODULE_ALIAS
Message-ID: <20110628080852.GD23305@infomag.iguana.be>
References: <1309185436.29085.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309185436.29085.3.camel@phoenix>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

> Remove the space between "platform:" prefix and the driver name.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Added to linux-2.6-watchdog-next for final testing.
Will go upsteam with other fixes this week.

Kind regards,
Wim.

