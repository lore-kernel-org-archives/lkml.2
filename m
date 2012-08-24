Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab2HXR3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 13:29:17 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:56304 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680Ab2HXR3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 13:29:13 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlNkAL25N1BV5qoUPGdsb2JhbABFhRojhQCwJxkBAQEBHhkNJ4IgAQEEATocIwULCAMOOBQlChqIGgq5UhSRJWADlVSFbI0O
X-IronPort-AV: E=Sophos;i="4.77,820,1336341600"; 
   d="scan'208";a="102613986"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Fri, 24 Aug 2012 19:34:08 +0200
To: Ferruh Yigit <fery@cypress.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Kevin McNeely <kev@cypress.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Shawn Landden <shawnlandden@gmail.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Olivier Sobrie <olivier@sobrie.be>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Input: cyttsp4 - bus driver for Cypress TMA4XX
 touchscreen devices
Message-ID: <20120824173408.GA6176@polaris.bitmath.org>
References: <fery@cypress.com>
 <1344344978-30453-1-git-send-email-fery@cypress.com>
 <50377C60.4020008@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50377C60.4020008@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ferruh,

> Hi Henrik,
> 
> Is driver reviewed and is there anything we can help on it?

As Javier mentioned, there is already a framework for the Cypress
devices in the kernel. Please make sure your patches build on what is
already there. Until then, I have nothing further to add.

Thanks,
Henrik
