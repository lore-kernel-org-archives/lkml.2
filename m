Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab0DZOQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 10:16:12 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:49808 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab0DZOQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 10:16:10 -0400
Date: Mon, 26 Apr 2010 16:16:05 +0200
From: Daniel Mack <daniel@caiaq.de>
To: =?utf-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org
Subject: Re: USB gadget with drivers "on board"
Message-ID: <20100426141605.GO30801@buzzloop.caiaq.de>
References: <op.vbrfqdznfxrvh1@pikus>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <op.vbrfqdznfxrvh1@pikus>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 10:29:05AM +0200, Michał Nazarewicz wrote:
> I need to create an USB gadget with drivers for Windows included
> "on board".  In particular, when the gadget is connected to Windows
> host it is detected as mass storage and mounted drive include the
> drivers.  However, when the drivers are installed, it is detected
> as some other device.
> 
> Now, it seems that a simple composite device with two configurations
> is enough -- the first containing mass storage and the second other
> functions.  My tests show that Windows manages to set the first
> configuration and detect the mass storage interface.

Why are you using two configurations on this device instead of one 
configuration with two interfaces? Interfaces are not allowed to share 
endpoints within one configuration, so they can be used simultaniously.

Daniel
