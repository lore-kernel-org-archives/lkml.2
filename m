Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab0JAS6y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 14:58:54 -0400
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:32938 "EHLO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0JAS6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 14:58:53 -0400
Message-ID: <4CA62F50.1070208@genband.com>
Date: Fri, 01 Oct 2010 12:58:24 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: khaled MOHAMMED atteya <khaled.m.atteya@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: what is x86 entry point?
References: <AANLkTik9NCgucKyi367HZKzEUJXE3ysRdyryQLnEAAMC@mail.gmail.com>
In-Reply-To: <AANLkTik9NCgucKyi367HZKzEUJXE3ysRdyryQLnEAAMC@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2010 18:56:56.0530 (UTC) FILETIME=[6B6C2B20:01CB619A]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-17678.001
X-TM-AS-Result: No--10.610600-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2010 09:27 AM, khaled MOHAMMED atteya wrote:
> I want to know where is entry point for x86 arch?
> Also i read on some papers there are many entry points in kernel ,
> which are these?

Take a look at arch/x86/kernel/entry_32.S (or entry_64.S) for starters.

Conceptually you can get into the kernel via old-school system calls,
the sysenter mechanism, page faults, interrupts, etc.

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
