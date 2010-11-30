Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298Ab0K3J47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 04:56:59 -0500
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:39055 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755228Ab0K3J45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 04:56:57 -0500
Message-ID: <4CF4CA45.6070702@stericsson.com>
Date: Tue, 30 Nov 2010 10:56:21 +0100
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 2/2] MFD: ab8500-debugfs irq support
References: <1290773229-9119-1-git-send-email-mattias.wallin@stericsson.com> <20101126155127.GE27663@sortiz-mobl>
In-Reply-To: <20101126155127.GE27663@sortiz-mobl>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> I think writing a UIO driver for that matter will make your life a lot easier.
> And to be honest, having an IRQ handler on a debugfs related piece of code
> sounds just wrong.
I was hoping for your input here. Can you elaborate on UIO driver?
What interface to user space do you suggest. I have requirements that a user space should be able to subscribe
and unsubscibe for one or several of the 112 ab8500 events.
Debugfs was the choice because I already had register access there and it can easily be compiled away.
I also wanted a clear connection to the irq_chip solution in the ab8500-core driver.
> 
> Cheers,
> Samuel.
> 
