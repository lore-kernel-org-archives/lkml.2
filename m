Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab1E3QZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 12:25:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:35502 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473Ab1E3QZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 12:25:31 -0400
Date: Mon, 30 May 2011 18:25:28 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] OHCI crash when handover fails
Message-ID: <20110530162528.GB2386@linutronix.de>
References: <1306454011.7481.529.camel@pasglop>
 <1306458168.7481.531.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1306458168.7481.531.camel@pasglop>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2011-05-27 11:02:48 [+1000]:

>BTW. The same handover failure didn't cause a crash yesterday, so this
>is a regression that happened with whatever Linus pulled last night, I
>probably won't have a chance to bisect it tho for various reasons.

Ben, this is probably fixed by
 http://marc.info/?l=linux-fsdevel&m=130676974227377&w=2

>Cheers,
>Ben.

Sebastian
