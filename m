Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab1FCRnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 13:43:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:59690 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1FCRnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 13:43:45 -0400
Date: Fri, 3 Jun 2011 19:43:42 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] OHCI crash when handover fails
Message-ID: <20110603174342.GC5424@linutronix.de>
References: <1306454011.7481.529.camel@pasglop>
 <1306458168.7481.531.camel@pasglop>
 <20110530162528.GB2386@linutronix.de>
 <1307001506.29297.61.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1307001506.29297.61.camel@pasglop>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2011-06-02 17:58:26 [+1000]:

>The patch does indeed fix the problem for me. I noticed that it's still
>not upstream tho :-) 

There is another version of the patch pending. I hope Greg picks it but
he is in .jp as far as I can see on lwn so it may take a while.

>Can you send it to Linus asap ?

The problem should go away for you if you disable CONFIG_USB_DEVICEFS :)
Nobody in userland should actually use this. udev and friends migrated
to the /sys interface.

>Cheers,
>Ben.

Sebastian
