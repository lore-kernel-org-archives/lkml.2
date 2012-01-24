Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab2AXQ5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:57:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:54651 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2AXQ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:57:12 -0500
Date: Tue, 24 Jan 2012 17:57:11 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Simon Glass <sjg@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: [PATCH] usb: Use a workqueue in usb_add_hcd() to reduce boot
 time
Message-ID: <20120124165711.GC3836@linutronix.de>
References: <CAPnjgZ0-VdAzudGFopBd+5j4HhOp10C=x0kPuJEZyaYSzwjBAA@mail.gmail.com>
 <Pine.LNX.4.44L0.1201211055180.24505-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201211055180.24505-100000@netrider.rowland.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Stern | 2012-01-21 11:11:09 [-0500]:

>Doing time-consuming things later won't make any difference.  That is,
>suppose the boot sequence performs activities A and B, where A takes a
>long time.  Doing A later, so that the boot sequence performs B and
>then A, won't change the total time required.

That is true. However if you show the gui _now_ and look for USB later
then it feels faster and this is usually enough.

>Alan Stern

Sebastian
