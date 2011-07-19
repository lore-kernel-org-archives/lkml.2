Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760Ab1GSJQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:16:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab1GSJQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:16:11 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: "Amit Blay" <ablay@codeaurora.org>
Subject: Re: [PATCH/RFC 5/5] usb: Add support for streams alloc/dealloc to devio.c
Date: Tue, 19 Jul 2011 11:18:48 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc6-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Tatyana Brokhman" <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        "Amit Blay" <ablay@qualcomm.com>,
        "open list" <linux-kernel@vger.kernel.org>
References: <1308231068-24038-2-git-send-email-tlinder@codeaurora.org> <20110630174538.GA7979@xanatos> <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org>
In-Reply-To: <8bcfda19cbc633e011e6b28a6183e68b.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107191118.48536.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 19. Juli 2011, 11:12:39 schrieb Amit Blay:

> > So it seems like you also need a way for userspace to specify which
> > endpoints get streams, and which endpoints have streams freed.  I will
> 
> What I have in mind is user space passing a structure holding:
> 
> 1. Interface number [IN]
> 2. Bitmap indicating which EP to allocate streams for [IN]

If this is a bitmap,

> 3. Number of streams to allocate, one number [IN}
> 4. Number of streams actually allocated, one number  [OUT]

how can those be scalars? 

	Regards
		Oliver
