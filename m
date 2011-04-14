Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab1DNWxK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:53:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52118 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab1DNWxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:53:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: /proc/acpi/wakeup regression in 2.6.39-rc3
Date: Fri, 15 Apr 2011 00:53:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
References: <20110414222525.GA24365@mac.home>
In-Reply-To: <20110414222525.GA24365@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150053.37037.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 15, 2011, Tino Keitel wrote:
> Hi,
> 
> with 2.6.38, I enabled wakeup from suspend to RAM with the USB keyboard
> this way:
> 
> echo USB2 > /proc/acpi/wakeup
> 
> This does not work anymore with 2.6.39-rc3. Wakeup using the keyboard
> won't work, and the USB2 line in /proc/acpi/wakeup doesn't change to
> "enabled" after the echo command.
> 
> Is this intended? If yes, what is the new way to enable keyboard
> wakeup?

No, it's supposed to work IIRC.  I'll have a look at that code tomorrow.

Thanks,
Rafael
