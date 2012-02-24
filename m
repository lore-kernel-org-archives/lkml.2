Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab2BXPk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:40:27 -0500
Received: from multi.imgtec.com ([194.200.65.239]:42872 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab2BXPkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:40:25 -0500
Message-ID: <4F47AF62.10507@imgtec.com>
Date: Fri, 24 Feb 2012 15:40:18 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in
 cond_syscall
References: <4F47981F.4020305@imgtec.com> <201202241424.07319.arnd@arndb.de> <4F47A3F3.5030504@imgtec.com> <201202241509.41809.arnd@arndb.de>
In-Reply-To: <201202241509.41809.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Feb 2012 15:40:18.0848 (UTC) FILETIME=[9C8B0200:01CCF30A]
X-SEF-Processed: 7_3_0_01181__2012_02_24_15_40_19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/02/12 15:09, Arnd Bergmann wrote:
> On Friday 24 February 2012, James Hogan wrote:
>> I've been looking at your initial comments for other architecture
>> submissions and they've been very helpful, but if you do have any
>> arch/metag specific suggestions I'd certainly welcome them.
> 
> I've had only a brief look. In general I recommend doing whatever
> openrisc does, they are currently the best implementation we have.

Okay, thanks for the tip.

> In order to get the code merged, you will need to move probing
> of on-chip buses to device trees rather than hardcoding the
> platform devices, that is probably the largest amount of work
> that is still needed unless you've done that already in a later
> version.

Okay, this is something I've been looking at.

> Do you have a git tree or patch with the latest source code?
> the only copy I could find is a 2.6.37 kernel inside of a huge
> tarball.

Sorry, but unfortunately that's the latest released version of the
kernel and I can't publish anything more recent at the moment.

Thanks
James

