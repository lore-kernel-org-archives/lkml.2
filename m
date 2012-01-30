Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2A3DmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 22:42:21 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54406 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab2A3DmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 22:42:19 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4F26118F.7090803@jp.fujitsu.com>
Date: Mon, 30 Jan 2012 12:42:07 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] PCI: pcie hotplug related patch
References: <1327139539-14301-1-git-send-email-yinghai@kernel.org> <CAE9FiQUFYcaVWorPPP7PQqiBPnKv-iBkPm_qbGz4T_xLR2THiQ@mail.gmail.com> <20120127103601.09e3f771@jbarnes-desktop> <CAE9FiQU70tBVCK-73x7kTX82XE3H03HTwP+HaS2E4_GqwMY1SQ@mail.gmail.com>
In-Reply-To: <CAE9FiQU70tBVCK-73x7kTX82XE3H03HTwP+HaS2E4_GqwMY1SQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/28 3:58), Yinghai Lu wrote:
> On Fri, Jan 27, 2012 at 10:36 AM, Jesse Barnes<jbarnes@virtuousgeek.org>  wrote:
>
>>>
>>>        git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>>> for-pci-hp
>>
>> Ok I dropped the earlier link state check; can you re-post the series
>> with Linus's comments addressed?
>
> resent.
>
> first one patch should get Linus's Ack, but he just said that solution
> is the best so far.
>
>>
>> Kenji-san, do you have time to at least review these?  Testing would be
>> nice too...
>
> others should already address all Kenji's reviews.
>

I have a chance to test the patches in this week. I will do it and report
the result. For some patches, I don't have any environment to reproduce
the problem the patch wants to solve. So it is difficult for me to confirm
the patch fix the problem. But I will test them from the regression
point of view.

Regards,
Kenji Kaneshige
