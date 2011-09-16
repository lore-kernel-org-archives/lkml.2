Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1IPRSa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:18:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:50578 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1IPRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:18:29 -0400
Date: Fri, 16 Sep 2011 19:18:25 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>, balbi@ti.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: add new usb gadget for ACM and mass storage
Message-ID: <20110916171824.GA23338@linutronix.de>
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <20110908191146.GA8552@suse.de>
 <op.v1jdo3g53l0zgt@mnazarewicz-glaptop>
 <20110909184354.GA30278@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20110909184354.GA30278@suse.de>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH | 2011-09-09 11:43:54 [-0700]:

>So we can expect more patches like this adding all of the possible
>permutations of the different gadget devices?
>
>If so, ick, I thought that the work that was done was to prevent this
>from happening, oh well :(

Would it be possible to come up with a gadget-hub driver which can have
multiple gadget attached? This should get rid of this kind of gadget
drivers, right?

>greg k-h

Sebastian
