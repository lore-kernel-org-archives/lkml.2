Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395Ab1F0Kf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 06:35:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:43598 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757518Ab1F0KfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 06:35:00 -0400
Message-ID: <4E085CD1.4040101@linutronix.de>
Date: Mon, 27 Jun 2011 12:34:57 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        sodaville@linutronix.de
Subject: Re: [PATCH v2 2/2] gpio: Add a driver for Sodaville GPIO controller
References: <1309159583-11339-1-git-send-email-bigeasy@linutronix.de>	<1309159583-11339-2-git-send-email-bigeasy@linutronix.de> <20110627103318.00c7b51c@pyx>
In-Reply-To: <20110627103318.00c7b51c@pyx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 27 Jun 2011 09:26:23 +0200
> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> 
>> Sodaville has GPIO controller behind the PCI bus. To my suprissed it is
>> not the same as on PXA.
> 
> Is it not the same as the Langwell one we already have ?

I don't see the mux register and lnw_gpio_set() uses two registers one for
set, one for get while Sodaville uses one register with bit set / unset
semantic. So it appears to be different.

Sebastian
