Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754547Ab1BBQWY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 11:22:24 -0500
Received: from www.tglx.de ([62.245.132.106]:40054 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427Ab1BBQWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 11:22:24 -0500
Message-ID: <4D4984B2.9080206@linutronix.de>
Date: Wed, 02 Feb 2011 17:22:10 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Andres Salomon <dilinger@queued.net>, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        dirk.brandewie@gmail.com
Subject: Re: [PATCH v2 01/15] x86/e820: remove conditional early mapping in
 parse_e820_ext
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-2-git-send-email-bigeasy@linutronix.de> <20101230083745.GC11721@angua.secretlab.ca> <20110104130839.GA21359@www.tglx.de> <20110114081446.GC21832@angua.secretlab.ca> <20110114105709.GA7562@www.tglx.de> <20110114134345.712e2e29@queued.net> <AANLkTimyrGkqtjo99+aV+N4KcrC2_3PprpRD2tRo_NtC@mail.gmail.com> <4D4808D2.3080701@linutronix.de> <20110201103617.2c3aa118@debxo> <AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>
In-Reply-To: <AANLkTi=kXaD0qhpHx30tFKN92pmAESSrXE1mz_55yuQO@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:
>> Perhaps it should be specifically checking for a fdt (by way of
>> initial_boot_params)?   Sparc also does not have initial_boot_params,
>> so one might even be able to drop an #ifdef in the process.
> 
> OLPC is very much the oddball in this case.  Everyone else uses
> devicetree for registering devices.  It could be solved by making OLPC
> explicitly register the RTC.

I second that :)

> 
> g.
> 

Sebastian
