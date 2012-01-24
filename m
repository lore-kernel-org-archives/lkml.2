Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2AXSjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 13:39:17 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:43401 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2AXSjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 13:39:15 -0500
Date: Tue, 24 Jan 2012 19:28:26 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Torne (Richard Coles)" <torne@google.com>, nic_swsd@realtek.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
Message-ID: <20120124182826.GA24128@electric-eye.fr.zoreil.com>
References: <1327343540-30348-1-git-send-email-torne@google.com> <20120123212914.747c852f@pyramind.ukuu.org.uk> <20120124171546.GA32184@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124171546.GA32184@atrey.karlin.mff.cuni.cz>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> :
[...]
> Kernel should provide hw abstraction, and that should mean doing
> something about commonly-bad ethernet cards.

Ask for a refund ?

> Userspace does not quite cut it, think about nfsroot for example.

nfsroot without pxe or such ? A bit contrieved imho.

The eeprom may be writable though. Or not :o/

-- 
Ueimor
