Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab0JNEad (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 00:30:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51808 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab0JNEac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 00:30:32 -0400
Date: Wed, 13 Oct 2010 21:29:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: akpm@linux-foundation.org, Johannes Berg <johannes.berg@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-10-13-17-13 uploaded (leds)
Message-Id: <20101013212902.2fec6413.randy.dunlap@oracle.com>
In-Reply-To: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
References: <201010140044.o9E0iuR3029069@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 17:13:25 -0700 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-10-13-17-13 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.36-rc7:
 
> led-class-always-implement-blinking.patch

When # CONFIG_LEDS_CLASS is not set
& CONFIG_LEDS_TRIGGERS=y:

drivers/built-in.o: In function `led_trigger_set':
(.text+0x4737b): undefined reference to `led_brightness_set'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
