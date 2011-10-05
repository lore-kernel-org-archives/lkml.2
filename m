Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934519Ab1JEMKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:10:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934417Ab1JEMKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:10:01 -0400
Message-ID: <4E8C48F9.2070707@redhat.com>
Date: Wed, 05 Oct 2011 14:09:29 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Jon Mason <jdmason@kudzu.us>
CC: Jon Mason <mason@myri.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: Workaround for Intel MPS errata
References: <4E82017C.3010304@redhat.com> <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com> <4E8215B6.1020108@redhat.com> <20110930001633.GA11436@myri.com> <4E882E34.8040409@redhat.com> <20111003045823.GA13222@myri.com> <4E898A69.8060306@redhat.com> <20111003151158.GA21955@myri.com> <4E8AD5F4.7000201@redhat.com> <4E8B04D8.5010107@redhat.com> <20111005034636.GA8618@kudzu.us>
In-Reply-To: <20111005034636.GA8618@kudzu.us>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2011 05:46 AM, Jon Mason wrote:
> Hey Avi,
> I believe this will fix the issue (assuming the errata is the issue in
> the first place).  You'll need to apply the patch on top of Linus'
> latest code and re-enable the MPS tuning (as it is now off by
> default).  This can be done by adding "pci=pcie_bus_safe" to your boot
> args.
>
> After thinking about it some more, a PCI quark is the correct way of
> doing things.  We must always disable read completion coalescing due
> to the possibility of hotplugging a device with a MPS of 256B.  Also,
> I believe everyone will think this is much cleaner.

Agree.

> Let me know how it goes and thanks again for testing this for me.

Works perfectly now.  Thanks.

-- 
error compiling committee.c: too many arguments to function

