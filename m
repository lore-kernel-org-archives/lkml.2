Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1EaRDQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:03:16 -0400
Received: from eu1sys200aog106.obsmtp.com ([207.126.144.121]:53830 "EHLO
	eu1sys200aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757303Ab1EaRDP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:03:15 -0400
Message-ID: <4DE51F26.4090306@stericsson.com>
Date: Tue, 31 May 2011 19:02:30 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 1/3] plat-nomadik: MTU sched_clock as an option
References: <1306830623-9504-1-git-send-email-mattias.wallin@stericsson.com> <20110531140357.GD21382@n2100.arm.linux.org.uk>
In-Reply-To: <20110531140357.GD21382@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 04:03 PM, Russell King - ARM Linux wrote:
> On Tue, May 31, 2011 at 10:30:23AM +0200, Mattias Wallin wrote:
>> This patch makes it possible to configure away the sched_clock
>> part of the MTU timer.
>
> We really need better changelogs than this.  Rather than saying just what
> the patch is doing, please also say _why_ the change is required - you
> can't expect people reading the patch to guess that kind of thing.
Thanks for the input Russell. I'll give it a new try.
