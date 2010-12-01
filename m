Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab0LAKbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 05:31:55 -0500
Received: from www.tglx.de ([62.245.132.106]:44178 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750965Ab0LAKby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 05:31:54 -0500
Message-ID: <4CF62405.3070205@linutronix.de>
Date: Wed, 01 Dec 2010 11:31:33 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: sodaville@linutronix.de, Jon Loeliger <jdl@jdl.com>, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [sodaville] [PATCH 04/11] x86/dtb: add irq host abstraction
References: <1290706801-7323-1-git-send-email-bigeasy@linutronix.de>	<1290706801-7323-5-git-send-email-bigeasy@linutronix.de>	<E1PLhWV-0004y7-44@jdl.com>  <4CEFC1EC.7030507@linutronix.de> <1290807372.32570.137.camel@pasglop>
In-Reply-To: <1290807372.32570.137.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> On Fri, 2010-11-26 at 15:19 +0100, Sebastian Andrzej Siewior wrote:
>> AFAIK Benh was thinking about renaming it. I don't know if this is
>> still
>> the case or when he intends to do so. Once he does so, this can be
>> renamed
>> as well. 
> 
> That and moving the powerpc code to a generic place so you don't have to
> re-invent your own :-)
> 
> I think Grant has patches for that.

I've found only patches which rename the struct, none that move it into
generic code. Should I rename mine and wait until it appears in generic
code?

> 
> Cheers,
> Ben.

Sebastian
