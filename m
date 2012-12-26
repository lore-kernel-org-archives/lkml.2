Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2LZSLr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 13:11:47 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:58096 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab2LZSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 13:11:44 -0500
Message-ID: <50DB378A.3090003@lwfinger.net>
Date: Wed, 26 Dec 2012 11:44:42 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
References: <Pine.LNX.4.44L0.1212261139060.15906-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1212261139060.15906-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2012 10:45 AM, Alan Stern wrote:

> I see.  Do you happen to have CONFIG_USB_EHCI_HCD=y and
> CONFIG_USB_EHCI_PCI=m in your .config?  If you do, try changing
> EHCI_PCI to y.

No, they are both "m". My configuration parameters with EHCI in them are

CONFIG_USB_ARCH_HAS_EHCI=y
CONFIG_USB_EHCI_HCD=m
# CONFIG_USB_EHCI_ROOT_HUB_TT is not set
CONFIG_USB_EHCI_TT_NEWSCHED=y
CONFIG_USB_EHCI_PCI=m
# CONFIG_USB_EHCI_HCD_PLATFORM is not set

The full configuration is posted at http://susepaste.org/5784418.

Larry

