Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618Ab1BCRT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:19:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34074 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756584Ab1BCRT5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:19:57 -0500
Message-ID: <4D4AE3AE.7000009@zytor.com>
Date: Thu, 03 Feb 2011 09:19:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andres Salomon <dilinger@queued.net>
Subject: RFC: can we kill the KEEP_SEGMENTS bzImage flag?
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   Bit 6 (write): KEEP_SEGMENTS
>         Protocol: 2.07+
>         - If 0, reload the segment registers in the 32bit entry point.
>         - If 1, do not reload the segment registers in the 32bit entry point.
>                 Assume that %cs %ds %ss %es are all set to flat segments with
>                 a base of 0 (or the equivalent for their environment).

Does anything actually rely on this bit or can we kill it?  I think it
was added as a crutch for paravirtualization, but I'm being told it is
not used...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

