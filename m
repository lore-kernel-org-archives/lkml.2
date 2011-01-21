Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab1AUKsq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 05:48:46 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:35736 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab1AUKsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 05:48:45 -0500
X-Auth-Info: KLGU9BAXUzT3T5j+UM7Bi2O8MSoLBUjyIHgTgzEuVO4=
From: Andreas Schwab <schwab@linux-m68k.org>
To: David Daney <ddaney@caviumnetworks.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: RTC seems broken on 2.6.38-rc1 for RTCs lacking alarms.
References: <4D38A051.2010301@caviumnetworks.com>
	<1295558196.2998.85.camel@work-vm>
	<AANLkTinJfQCEcqHy8oc8+F+yrmY_AkhPLCdZ7R95tk6H@mail.gmail.com>
	<1295562203.2998.105.camel@work-vm>
	<4D38BD2A.2070705@caviumnetworks.com>
X-Yow: I'd like TRAINED SEALS and a CONVERTIBLE on my doorstep by NOON!!
Date: Fri, 21 Jan 2011 11:48:45 +0100
In-Reply-To: <4D38BD2A.2070705@caviumnetworks.com> (David Daney's message of
	"Thu, 20 Jan 2011 14:54:34 -0800")
Message-ID: <m2fwsm7cs2.fsf@whitebox.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Daney <ddaney@caviumnetworks.com> writes:

> John,
>
> With that patch, it works now.  Thanks.

Works here as well.

Thanks, Andreas.

-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
