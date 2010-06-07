Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab0FGSPV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 14:15:21 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:11039 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab0FGSPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 14:15:20 -0400
Message-ID: <4C0D36C3.4040709@monstr.eu>
Date: Mon, 07 Jun 2010 20:13:23 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] arch/microblaze fixes for 2.6.35-rc3
References: <4C0CF9DF.2050603@monstr.eu> <alpine.LFD.2.00.1006071052410.3515@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1006071052410.3515@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 7 Jun 2010, Michal Simek wrote:
>> please pull the following changes.
> 
> No. See my -rc2 announcement. Also, this has clearly not even been tested, 
> since it's been rebased on top of a recent commit.
> 
> So I'm being a hard-ass this time around. I don't care what subsystem it 
> is, I want pull requests to follow the after-merge-window rules. 
> Regressions, security bugs, and major oopses. Not just random changes.

ok. No problem. There is only 2-3 patches which bring new functionality.
The rest is bug fixes. I am going to send next pull request just with fixes.

Michal

> 
> 			Linus


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
