Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab1LPGkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 01:40:20 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63680 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985Ab1LPGkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 01:40:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111215213822.GB2561@tuxdriver.com>
References: <20111215191523.GA2561@tuxdriver.com>
	<CACna6rw736JdkoM8zKxorCFd5oy08QTwWZ6PutoJPSr3ZN8hTg@mail.gmail.com>
	<20111215213822.GB2561@tuxdriver.com>
Date: Fri, 16 Dec 2011 07:40:16 +0100
Message-ID: <CACna6rz3qDpw4eJOoCXx7=z1719v7kS-Ou-WUseR9_vB-O2dag@mail.gmail.com>
Subject: Re: pull request: wireless 2011-12-15
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        Arend Van Spriel <arend@broadcom.com>
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 15 grudnia 2011 22:38 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Thu, Dec 15, 2011 at 09:04:29PM +0100, Rafał Miłecki wrote:
>> 2011/12/15 John W. Linville <linville@tuxdriver.com>:
>> > commit 42a3b63bb2ca4996a3d1210a004eae2333f1119e
>> >
>> > Dave,
>> >
>> > Here are a few more fixes intended for the 3.2 release.  They are
>> > all small and narrowly focused.
>>
>> John, I've made a mistake and didn't use [PATCH 3.2] header to make it
>> clean my patch is fix. Could you take a look at
>> [PATCH] bcma: support for suspend and resume
>> please?
>>
>> It's not one-liner, but fixes lock ups, which I believe - we really
>> want to avoid.
>
> It's late in the release cycle, and Dave specifically asked me to slow down.
>
> Are these suspend/resume lockups a regression?  Or have they always
> been there?  Do they happen to everyone?

The bug is present since first days of bcma. That's why I even decided
to add stable to CC.

Personally I've tested that only on 1 machine (I don't have more
suspendable machines with mini PCIe slot). However all Macbook 8.1/8.2
users have to remove b43 & bcma before suspending [0], they complain
about that since ever.

Arend: I know you're also complaining for suspend in bcma. Can you
comment on this?

[0] http://ubuntuforums.org/showthread.php?t=1695746

-- 
Rafał
