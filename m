Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933046Ab1D0Ryg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:54:36 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:53004 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759671Ab1D0Rye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:54:34 -0400
Date: Wed, 27 Apr 2011 14:54:32 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: kernel panic after unplug usb bluetooth dongle
Message-ID: <20110427175432.GA2328@joana>
Mail-Followup-To: Dave Young <hidave.darkstar@gmail.com>,
	Bluettooth Linux <linux-bluetooth@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <BANLkTi=UG0Xy2UEkNj2S_bS-PjOG5krNkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=UG0Xy2UEkNj2S_bS-PjOG5krNkQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dave Young <hidave.darkstar@gmail.com> [2011-04-27 14:35:59 +0800]:

> Hi,
> 
> Unplug usb bluetooth dongle make kernel panic as below. Thomas, any
> idea about it?

Commit b79f44c16a4 on 

	git://git.kernel.org/pub/scm/linux/kernel/git/padovan/bluetooth-2.6.git

fixes this. The only problem is that it didn't arrive at mainline yet.

-- 
Gustavo F. Padovan
http://profusion.mobi
