Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab2BMWX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:23:59 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35870 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2BMWX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:23:57 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6619"; a="160549624"
Message-ID: <4F398D61.9080501@codeaurora.org>
Date: Mon, 13 Feb 2012 14:23:29 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <alpine.LFD.2.02.1202022016480.2759@xanadu.home> <1328234629-32735-1-git-send-email-sboyd@codeaurora.org> <CAH+eYFCKcPzMMp_Ef5iX0Xp=xK8MdvJoUBRgKGT56SVjY5DXoA@mail.gmail.com> <alpine.LFD.2.02.1202131307430.24536@xanadu.home> <4F3952C7.3040502@codeaurora.org> <20120213181501.GD25655@n2100.arm.linux.org.uk>
In-Reply-To: <20120213181501.GD25655@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/12 10:15, Russell King - ARM Linux wrote:
> On Mon, Feb 13, 2012 at 10:13:27AM -0800, Stephen Boyd wrote:
>> Thanks. Russell has already merged the original patch to the fixes
>> branch. Hopefully he can fold this one in.
> Nope, I've asked Linus to pull it.
>
> So do we conclude that the original patch wasn't properly tested? :P

Sigh. Lockdep strikes again! I promise I tested it with lockdep disabled.

It looks like Linus' hasn't pulled yet but maybe he just hasn't
published it.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

