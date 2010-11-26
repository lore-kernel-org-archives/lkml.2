Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0KZLFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 06:05:45 -0500
Received: from www.tglx.de ([62.245.132.106]:41318 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0KZLFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 06:05:44 -0500
Message-ID: <4CEF93F1.4080902@linutronix.de>
Date: Fri, 26 Nov 2010 12:03:13 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 10/11] x86/io_apic: add simply id set
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-11-git-send-email-bigeasy@linutronix.de> <AANLkTikBHcRkgvzCi3jRLiRHLSPT93Gm1Kkwx35fXBeA@mail.gmail.com>
In-Reply-To: <AANLkTikBHcRkgvzCi3jRLiRHLSPT93Gm1Kkwx35fXBeA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Nov 25, 2010 at 9:40 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>> This one goes through the registered IO-APICs and sets the id which the
>> core code is using.
> 
> can you update and split setup_ioapic_ids_from_mpc() for your using?

Probably, let me see.

> Thanks
> 
> Yinghai


Sebastian
