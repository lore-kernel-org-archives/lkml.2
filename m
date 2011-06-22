Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1FVUPa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 16:15:30 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:37814 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758537Ab1FVUP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 16:15:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EADxMAk5tgwPS/2dsb2JhbABTpxB4iHMCwQMOhh8EoXg
Date: Wed, 22 Jun 2011 22:15:26 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110622201526.GF26745@infomag.iguana.be>
References: <20110618171946.GB3441@infomag.iguana.be> <201106182058.14702.arnd@arndb.de> <20110619204400.d732e8aa.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110619204400.d732e8aa.rdunlap@xenotime.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

> This info in Documentation/ioctl/ioctl-number.txt does not change, correct?
> 
> 'W'	00-1F	linux/watchdog.h	conflict!

Indeed, the goal is to extract common code out of all watchdog drivers.
So the ioctl calls have stayed the same.

Kind regards,
Wim.

