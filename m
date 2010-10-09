Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611Ab0JIWyP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:54:15 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53927 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655Ab0JIWyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:54:14 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4CB0F28A.6090405@s5r6.in-berlin.de>
Date: Sun, 10 Oct 2010 00:54:02 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: linux1394-devel@lists.sourceforge.net
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ieee1394: move init_ohci1394_dma to drivers/firewire/
References: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
In-Reply-To: <tkrat.a80c49c9cfb3380e@s5r6.in-berlin.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Additional changes:
>   - add some #include directives
>   - adjust to use firewire/ohci.h instead of ieee1394/ohci1394.h,
>     replace struct ti_ohci by a minimal struct ohci,
[...]
> +struct ohci {
> +	struct pci_dev *dev;
> +	void __iomem *registers;
> +};

The dev member is actually unused to.  I'll remove it but keep the now rather
useless struct ohci so that the code stays similar to ohci.c.
-- 
Stefan Richter
-=====-==-=- =-=- -=-=-
http://arcgraph.de/sr/
