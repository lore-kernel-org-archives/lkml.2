Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451Ab2LNVxg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:53:36 -0500
Received: from londo.lunn.ch ([80.238.139.98]:46700 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932303Ab2LNVxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:53:36 -0500
Date: Fri, 14 Dec 2012 22:53:21 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Dave Jones <davej@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lentin <jm@lentin.co.uk>, Simon Baatz <gmbnomis@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>
Subject: Re: power: Add simple poweroff-gpio driver
Message-ID: <20121214215321.GD7717@lunn.ch>
References: <20121213202157.8106C66071E@gitolite.kernel.org>
 <20121213205159.GA21825@redhat.com>
 <20121214082150.GA7717@lunn.ch>
 <20121214150841.GA15843@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214150841.GA15843@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > Its a generic driver. I know its useful on various Marvell kirkwood
>  > and orion5x devices. I've also heard it useful on some Tegra boards.
>  > 
>  > Are you asking i list these boards?
> 

> No, but at least mentioning the architecture might have clued me in
> quicker that this wasn't some now ACPI-ism when I saw it on x86.

Hi Dave

It is architecture independent. There are examples of ARM, AVR32, &
unicore32 boards which could use this and there might be more.

	  Andrew
  
