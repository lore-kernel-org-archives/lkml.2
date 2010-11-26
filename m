Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0KZJGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 04:06:47 -0500
Received: from www.tglx.de ([62.245.132.106]:49070 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328Ab0KZJGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 04:06:45 -0500
Message-ID: <4CEF7892.9020103@linutronix.de>
Date: Fri, 26 Nov 2010 10:06:26 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        Dirk Brandewie <dirk.brandewie@gmail.com>
Subject: Re: [PATCH 02/11] x86: Add device tree support
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de> <1290706801-7323-3-git-send-email-bigeasy@linutronix.de> <20101125225337.GA21223@merkur.ravnborg.org>
In-Reply-To: <20101125225337.GA21223@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> +++ b/arch/x86/include/asm/prom.h
>> +#ifdef __KERNEL__
> 
> This file is not exported to userspace - so no need to guard with __KERNEL__

Removed.

> 
> 	Sam

Sebastian
