Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138Ab2EUHrh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:47:37 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:41097 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab2EUHrf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:47:35 -0400
Message-ID: <4FB9F311.9000004@sysgo.com>
Date: Mon, 21 May 2012 09:47:29 +0200
From: Alexander Sverdlin <asv@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.27) Gecko/20120216 Lightning/1.0b2 Thunderbird/3.1.19
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, alexander.sverdlin.ext@nsn.com
Subject: Re: Possible race in request_irq() (__setup_irq())
References: <4FB39EDA.3030807@sysgo.com> <alpine.LFD.2.02.1205161512270.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205161512270.3231@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Thomas,

On 05/16/2012 03:44 PM, Thomas Gleixner wrote:
> I don't know what your archaeologic kernel version is doing there, but
> the current cavium code only uses handle_percpu_irq flow handler for a
> handful special interrupts which are handled and setup by the cavium
> core code correctly.
> 
> So nothing to fix here.

Thanks for clarification!
I'll clean-up all our IRQ code, remove unnecessary PER_CPU flags and drop a note, how it helped.

-- 
Best regards,
Alexander Sverdlin.
