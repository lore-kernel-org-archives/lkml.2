Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1HFRHL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 13:07:11 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:53766 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753296Ab1HFRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 13:07:08 -0400
X-Sasl-enc: VMXNMMwnJzucAg0mUxYZvQLc2EMI/QRRY7Vk2U5MN36+ 1312650427
Date: Sat, 6 Aug 2011 09:04:13 -0700
From: Greg KH <greg@kroah.com>
To: Alexandre Felipe Muller de Souza <alexandrefm@mandriva.com.br>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: USB 3.0 Hub and USB 3.0 Device
Message-ID: <20110806160413.GA25595@kroah.com>
References: <1311370548.16334.90.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311370548.16334.90.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 06:35:48PM -0300, Alexandre Felipe Muller de Souza wrote:
> Hi all, 
> I had some problems with USB 3.0 on stable kernels (2.6.38 and 2.6.39)
> it does not detect the device. I had to rmmod xhci_hcd && modprobe
> xhci_hcd with the device attached on port to detect. And then it works
> ok.
> It works on 3.0 kernel, but I can't update to it since its not stable
> already. I tried to backport the xhci_hcd but it's impossible, its too
> much line code. I tried other ugly fixes like removing and loading the
> module automatically, but maybe there is another fix.
> 
> I tested on current stable branches but no one works well, if there is a
> solution please reply me.

Use the 3.0 release please.

greg k-h
