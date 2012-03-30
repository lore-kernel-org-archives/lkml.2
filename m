Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934202Ab2C3L3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 07:29:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50401 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933785Ab2C3L26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 07:28:58 -0400
Date: Fri, 30 Mar 2012 13:28:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Borislav Petkov <bp@alien8.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <greg@kroah.com>, linux-usb@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: menuconfig looks funny since recently, i.e. USB gains on importance
 :)
In-Reply-To: <20120330100056.GA27427@x1.osrc.amd.com>
Message-ID: <alpine.LRH.2.00.1203301328330.22234@twin.jikos.cz>
References: <20120330100056.GA27427@x1.osrc.amd.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Borislav Petkov wrote:

> Hi guys,
> 
> Linus tree from today gives the following in menuconfig:
> 
> 
> ...
>   │ │                            Graphics support  --->
>   │ │                        < > Sound card support  --->
>   │ │                        [*] HID Devices  --->
>   │ │                        [*] USB support  --->
>   │ │                        <*> Support for Host-side USB
>   │ │                        [ ]   USB verbose debug messages
>   │ │                        [*]   USB announce new devices
>   │ │                              *** Miscellaneous USB options ***
>   │ │                        [ ]   USB device filesystem (DEPRECATED)
>   │ │                        [ ]   USB device class-devices (DEPRECATED)
>   │ │                        [ ]   Dynamic USB minor allocation
>   │ │                        [*]   USB runtime power management (autosuspend) and wakeup
>   │ │                        [ ]     OTG support
>   │ │                        <*> USB Monitor
>   │ │                        < > Support WUSB Cable Based Association (CBA)
>   │ │                            *** USB Host Controller Drivers ***
>   │ │                        < > Cypress C67x00 HCD support
>   │ │                        <M> xHCI HCD (USB 3.0) support (EXPERIMENTAL)
>   │ │                        [ ]   Debugging for the xHCI host controller
>   │ │                        <M> EHCI HCD (USB 2.0) support
>   │ │
>   │ │                        [ ]   Root Hub Transaction Translators
>   │ │                        [ ]   Improved Transaction Translator scheduling
>   │ │                        < > OXU210HP HCD support
>   │ │                        < > ISP116X HCD support
>   │ │                        < > ISP 1760 HCD support
>   │ │                        < > ISP1362 HCD support
>   │ │                        <M> OHCI HCD support
> ...
> 
> This is the "Device Drivers" menu and all the USB-related options should
> appear in the submenu "USB support" but they're merged with the "Device
> Drivers" menu. Looks like someone funnied up Kconfig somewhere...

Caued by 53c6bc24fdc, adding David Daney.

-- 
Jiri Kosina
SUSE Labs

