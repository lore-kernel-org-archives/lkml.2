Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754749Ab1DKHXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 03:23:45 -0400
Received: from www.linutronix.de ([62.245.132.108]:54823 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424Ab1DKHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 03:23:44 -0400
Date: Mon, 11 Apr 2011 09:23:40 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, monstr@monstr.eu,
        tglx@linutronix.de
Subject: Re: [PATCH] x86/ce4100: add reg property to bridges
Message-ID: <20110411072340.GA4018@linutronix.de>
References: <1302146796-26825-1-git-send-email-benh@kernel.crashing.org>
 <1302146796-26825-2-git-send-email-benh@kernel.crashing.org>
 <20110407121315.GA9204@linutronix.de>
 <1302213159.2458.43.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1302213159.2458.43.camel@pasglop>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt | 2011-04-08 07:52:39 [+1000]:

>Thanks. Are you sending that independently or do you want me to put it
>in my series before the patch that would "break" it ?

I would prefer to get it into 39 so I don't have a device tree which
does not work on a later kernel version.

>Cheers,
>Ben.

Sebastian
