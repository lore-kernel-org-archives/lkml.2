Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089Ab1COQCT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:02:19 -0400
Received: from dd8000.kasserver.com ([85.13.132.92]:38929 "EHLO
	dd8000.kasserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758016Ab1COQCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:02:18 -0400
Message-ID: <4D7F8C53.7000705@gmx.net>
Date: Tue, 15 Mar 2011 16:57:07 +0100
From: Otto Meier <gf435@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [regression]2.6.38-rc6 with XFS still does consume all free space
References: <4D63A9E7.3000803@gmx.net> <20110301035101.GH3087@dastard>
In-Reply-To: <20110301035101.GH3087@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.03.2011 04:51, schrieb Dave Chinner:
> On Tue, Feb 22, 2011 at 01:19:51PM +0100, Otto Meier wrote:
>> Hello,
>> on my System a "make modules_install" with kernel 2.6.38-rc6 has eaten up
>> all free Space on a XFS partition.
> Are you building the 2.6.38-rc6 kernel on some other kernel or are
> you running 2.6..38-rc6?
>
I did build a new newer Kernel and was running 2.6.38-rc6.
>> The free Space is
>>
>> /dev/sda6             56472984  43613692  12859292  78% /
>>
>> after make modules_install i get
>>
>> /dev/sda6             56472984  56472964        20 100% /
> Had you already built the kernel, or did the make command build the
> kernel and all the modules before installing them?  Can you check
> how much space the modules directory is actually using (i.e. using
> du)?
>
> Also, did you get an ENOSPC error?
>
I had already build the kernel.
>> with kernel 2.6.37.1 everything runs fine and df shows
>>
>> /dev/sda6             56472984  43262256  13210728  77% /
>>
>> any idea what is going on here?
> No, all the known preallocation regressions have been fixed. can you
> confirm that the kernel you are running has this commit in it?
>
> b8fc826 xfs: speculative delayed allocation uses rounddown_power_of_2 badly
>
Yes the kernel I was running had this commit.
> Cheers,
>
> Dave.
Sorry for not answering earlier,  I added my comments to your questions above.

Bye Otto

