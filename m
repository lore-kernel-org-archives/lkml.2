Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572Ab2A0TIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:08:13 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54597 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab2A0TIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:08:11 -0500
MIME-Version: 1.0
In-Reply-To: <20120127103305.5fdb8de3@jbarnes-desktop>
References: <4ED95AD0.7090003@oracle.com>
	<20120127092622.6d8c2ae8@jbarnes-desktop>
	<4F22E136.5010404@oracle.com>
	<20120127103305.5fdb8de3@jbarnes-desktop>
Date: Fri, 27 Jan 2012 11:08:10 -0800
X-Google-Sender-Auth: cCq9phKIAFjwTN5fHdhHwrAP0-w
Message-ID: <CAE9FiQXvNmRxOFBJDeSvRUyPgQAFUT1_0m9q-i5qTMC-=LqcKw@mail.gmail.com>
Subject: Re: [PATCH] pciehp: Disable/enable link during slot power off/on
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 10:33 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Fri, 27 Jan 2012 09:39:02 -0800
> Yinghai Lu <yinghai.lu@oracle.com> wrote:
>> Please you check updated versions that i sent later.
>>
>> it was changed to three patches... i sent those patchs 1/123
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-hp
>>
>> you can find other patches in
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci2
>>
>> and
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git for-pci-busn-alloc
>
> Ok I'll see if I can dig them out of the list; note I can't pull
> directly from your branches since I usually need to rewrite the
> changelogs and the patches need careful review.

Agreed, I just put them into tree for your reference, in case you are
picking up a wrong version from mail.

Thanks

Yinghai
