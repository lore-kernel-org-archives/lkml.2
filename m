Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab1E0RO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 13:14:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43472 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612Ab1E0RO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 13:14:57 -0400
Message-ID: <4DDFDBD2.2000904@zytor.com>
Date: Fri, 27 May 2011 10:13:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Dan Rosenberg <drosenberg@vsecurity.com>
CC: Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>	 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>	 <20110527170045.GB4356@elte.hu> <1306516230.3339.17.camel@dan>
In-Reply-To: <1306516230.3339.17.camel@dan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 10:10 AM, Dan Rosenberg wrote:
> 
> Just to play devil's advocate, how is it easier for a local attacker to
> figure out where kernel internals are if it's been relinked vs.
> randomized at load time, assuming we follow through on fixing the info
> leaks?
> 

You can read the on-disk kernel file and find out.

	-hpa
