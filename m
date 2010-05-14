Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab0ENFxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 01:53:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:42182 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046Ab0ENFw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 01:52:58 -0400
Message-ID: <4BECE509.8040308@monstr.eu>
Date: Fri, 14 May 2010 07:52:09 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.34-rc8
References: <4BEBE8C8.3090202@monstr.eu> <alpine.LFD.2.00.1005131447100.3711@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1005131447100.3711@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 13 May 2010, Michal Simek wrote:
>>   git://git.monstr.eu/linux-2.6-microblaze.git for-linus
> 
> Hmm. I'm getting
> 
> 	fatal: unable to connect a socket (Connection timed out)
> 
> for that machine right now.

I have tested it and I can't see this problem. The server is in 
Australia - maybe any temporary fault.

Anyway. Yesterday, I have found one more bug which I added. I am going 
to send new pull request. I hope that there won't be any problem with 
connection.

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
