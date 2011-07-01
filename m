Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1GALAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:00:08 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:27474 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762Ab1GALAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:00:05 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAHWnDU5tg1zt/2dsb2JhbABSp154iHkCwDwOhiQEomU
Date: Fri, 1 Jul 2011 13:00:02 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH 2/2] Add watchdog driver for Intel TunnelCreek
Message-ID: <20110701110002.GA9326@infomag.iguana.be>
References: <1308222350-21634-1-git-send-email-alexander.stein@systec-electronic.com> <1308222350-21634-2-git-send-email-alexander.stein@systec-electronic.com> <36169.1308344475@turing-police.cc.vt.edu> <201106201051.49055.alexander.stein@systec-electronic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106201051.49055.alexander.stein@systec-electronic.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

> Thanks for the hint.
> Would you also recommend to rename the driver module name? Currently it is 
> intel_tunnelcreek_watchdog, so it may be called intel_e6xx_watchdog.

I would prefer e6xx_wdt or ie6xx_wdt or something similar.
Just look at the naming of other Intel based platforms: iop, ixp2xx, ixp4xx, iTCO, ...

Kind regards,
Wim.

