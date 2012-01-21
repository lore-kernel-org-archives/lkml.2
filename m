Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2AUIjy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:39:54 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35809 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab2AUIju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:39:50 -0500
Message-ID: <4F1A7854.7010808@gmail.com>
Date: Sat, 21 Jan 2012 09:33:24 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] ramoops: use pstore interface
References: <20120117235852.GA4877@www.outflux.net>	<20120118140603.0fc22302.akpm@linux-foundation.org>	<CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>	<5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com> <CAGXu5jJ3WMUDS0svkoviLx_OOQFdjofMt3PwHdeLiouFbDVShw@mail.gmail.com> <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F237@USINDEVS01.corp.hds.com>
In-Reply-To: <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F237@USINDEVS01.corp.hds.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/01/2012 00:20, Seiji Aguchi ha scritto:
>>> Are there any specific usecases you need to unload ramoops?
>>
>> For me, it would be useful during development. Beyond that, not that I can see.
>
> Thank you for your quick relay. I understood this is useful for you.
>
> But, as Tony said, I think this is a low priority because
> there is a side effect for end users.
> If they unload ramoops by mistake, messages will be lost.
>
> In my opinion, we have to consider whether each feature
> is truly needed for end users (not for developers).
>
> Seiji
>
>

First of all ramoops was born mainly for debug purpose and to help the 
maintainability of a product. I used it in systems where the uptime (so 
no reboot) was important. So it can be very useful for me load the 
module, gather logs and unload it for example. A kernel panic is not 
recoverable so the reboot is needed but it's not always true for a 
kernel oops.

Marco
