Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161Ab2DKT5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 15:57:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:44832 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab2DKT5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 15:57:15 -0400
Message-ID: <4F85E217.8060406@kernel.dk>
Date: Wed, 11 Apr 2012 21:57:11 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: mtip32xx: remove HOTPLUG_PCI_PCIE dependancy
References: <20120411183457.GA19379@kroah.com>
In-Reply-To: <20120411183457.GA19379@kroah.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-11 20:34, Greg KH wrote:
> This removes the HOTPLUG_PCI_PCIE dependency on the driver and makes it
> depend on PCI.

I think it's an old dependency. I've built and run it here without as
well, and no functional issues either.

Sam/Asai?

-- 
Jens Axboe

