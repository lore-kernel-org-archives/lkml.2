Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab1ELK65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 06:58:57 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:2580 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178Ab1ELK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 06:58:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAK+8y01tggPx/2dsb2JhbACEVaEbeLdHkSOBK4NjgQcEhkmYOQ
Date: Thu, 12 May 2011 05:58:48 -0500
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: Arnd Bergmann <arnd@arndb.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com,
        Subhasish Ghosh <subhasish@mistralsolutions.com>, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
        m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Message-ID: <20110512105822.GA252@e-circ.dyndns.org>
Mail-Followup-To: Wolfgang Grandegger <wg@grandegger.com>,
	Arnd Bergmann <arnd@arndb.de>, sachi@mistralsolutions.com,
	davinci-linux-open-source@linux.davincidsp.com,
	Subhasish Ghosh <subhasish@mistralsolutions.com>, nsekhar@ti.com,
	open list <linux-kernel@vger.kernel.org>,
	CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
	m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>
 <2BFFDAA0A0DE4820876E5549867938EC@subhasishg>
 <201105112331.47954.arnd@arndb.de>
 <201105112344.44171.arnd@arndb.de>
 <4DCB88A4.2010901@grandegger.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4DCB88A4.2010901@grandegger.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 09:13:40AM +0200, Wolfgang Grandegger wrote:
> A simple interface using:
> 
>   ip link set can0 type can filter <id>:<mask> [<id>:<mask> ...]
> 
> would just be fine.
Yep.
