Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab1AZT2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:28:16 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:34278 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751435Ab1AZT2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:28:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAI8EQE1Ld/sX/2dsb2JhbAAMhAbNfZEDgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,381,1291611600"; 
   d="scan'208";a="89334059"
Message-ID: <4D4075CD.8060402@teksavvy.com>
Date: Wed, 26 Jan 2011 14:28:13 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D401CC5.4020000@redhat.com> <4D402D35.4090206@redhat.com> <20110126165132.GC29163@core.coreip.homeip.net> <4D4059E5.7050300@redhat.com> <20110126182415.GB29268@core.coreip.homeip.net> <4D4072F9.5060206@redhat.com>
In-Reply-To: <4D4072F9.5060206@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 02:16 PM, Gerd Hoffmann wrote:
>   Hi,
> 
>>>> The check should be against concrete version (0x10000 in this case).
> 
> Stepping back: what does the version mean?
> 
> 0x10000 == 1.0 ?
> 0x10001 == 1.1 ?
> 
> Can I expect the interface stay backward compatible if only the minor revision
> changes, i.e. makes it sense to accept 1.x?
> 
> Will the major revision ever change?  Does it make sense to check the version at
> all?

As already established earlier in this thread,
by Linus Torvalds as well as by myself,
NO!

That whole "version" concept is broken and inappropriate.
Userspace should simply ignore it completely.

Cheers
