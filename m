Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab2BJRHz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 12:07:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49252 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800Ab2BJRHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 12:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <20120210153546.GA5109@comet.dominikbrodowski.net>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
	<1327140517-14811-19-git-send-email-yinghai@kernel.org>
	<20120127102311.6027ea2c@jbarnes-desktop>
	<CAE9FiQXQPFYU45rctaNX4kSqh7JGCnds8U-Bh1N93xVieuqz5Q@mail.gmail.com>
	<20120205215824.GA5071@comet.dominikbrodowski.net>
	<CAE9FiQXvU-GCDSVMGvUT23WMMVmbyHpQOApuAp5mV+=UOPf_1Q@mail.gmail.com>
	<20120210153546.GA5109@comet.dominikbrodowski.net>
Date: Fri, 10 Feb 2012 09:07:53 -0800
X-Google-Sender-Auth: mFUvnWy3HLTx9wJNtn6PPpdhrRQ
Message-ID: <CAE9FiQUnw17uFMBHJh65vCGWwfx3SQAcO3NG02=2S0LKP++Heg@mail.gmail.com>
Subject: Re: [PATCH 18/21] PCI: Fix cardbus bridge resources as optional size handling
From: Yinghai Lu <yinghai@kernel.org>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Yinghai Lu <yinghai@kernel.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 7:35 AM, Dominik Brodowski
<linux@dominikbrodowski.net> wrote:

>> Found another regression by one commit already got into linus' tree.
>>
>> and should be fixed by
>>
>> [PATCH] pci: Fix pci cardbus removal
>>
>> http://git.kernel.org/?p=linux/kernel/git/yinghai/linux-yinghai.git;a=patch;h=29834f2faeed3cb87dea984a3d411337752e6b7c
>>
>> please double check
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci3
>>
>> or
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
>> for-pci-busn-alloc
>
> I pulled both trees, and things still work fine on my test system.

thanks a lot

Yinghai
