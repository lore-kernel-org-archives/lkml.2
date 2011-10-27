Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1J0TRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 15:17:19 -0400
Received: from exprod7og108.obsmtp.com ([64.18.2.169]:35027 "EHLO
	exprod7og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab1J0TRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 15:17:18 -0400
Message-ID: <4EA9AE06.1030104@genband.com>
Date: Thu, 27 Oct 2011 13:16:22 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110928 Fedora/3.1.15-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.15
MIME-Version: 1.0
To: Lasse Penttinen <lasse.penttinen@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Bug 877666] Dell XT2 touchpad not recognized
References: <20111018190255.7837.17923.malonedeb@chaenomeles.canonical.com>	<20111026210627.20335.40050.malone@wampee.canonical.com>	<CAGpevg-JhuxLp+59N+DUGHUwe3M3qrdyocEfLgtvOE4e8+Uu1A@mail.gmail.com> <CAGpevg_d81CwTR=uoDf90iuoTWg6uEiTogO4Bp08fE5Ku9TrxQ@mail.gmail.com>
In-Reply-To: <CAGpevg_d81CwTR=uoDf90iuoTWg6uEiTogO4Bp08fE5Ku9TrxQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Oct 2011 19:16:24.0165 (UTC) FILETIME=[EAE76150:01CC94DC]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18476.001
X-TM-AS-Result: No--8.446700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2011 01:04 PM, Lasse Penttinen wrote:
> Hello Kernel Devs,
>
> I was asked by Ubuntu team to report this bug upstream (my 1st).
> However the kernel.org bugzilla seems to be down, so mailing list is
> my only alternative. Unfortunately I did not find any template or such
> for reporting via email, so here goes.

Information on reporting bugs is available in the "REPORTING-BUGS" file 
in the kernel source, or online at:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=REPORTING-BUGS

> Bug description: The touchpad of Dell XT2 is recognized as a plain
> PS/2 mouse, and therefore any touchpad related settings are not
> available (like disabling it while typing..)
>
> Reproducable: I have reproduced this with Ubuntu 11.10
> (3.0.0-12-generic) and with Fedora 16 beta live CD just to make sure.

Based on the comments at 
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/550625 it appears 
that you've tried the Ubuntu version of the ALPS touchpad patches by 
Seth Forshee, is that correct?  If so, that's an important data point.

Chris




-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
