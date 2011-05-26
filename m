Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614Ab1EZWdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 18:33:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38891 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754820Ab1EZWdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 18:33:38 -0400
Message-ID: <4DDED4ED.7020806@zytor.com>
Date: Thu, 26 May 2011 15:32:13 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Dan Rosenberg <drosenberg@vsecurity.com>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
In-Reply-To: <201105270018.36835.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
> 
> Well, as far as I can tell, this feature is going to break hibernation on
> both x86_32 and x86_64 at the moment, unless you can guarantee that the
> randomized kernel location will be the same for both the boot and the target
> kernels.
> 

Obviously we can't and we don't.  I'm a bit surprised at that
constraint... how can that constraint not break things like kernels of
slightly different size?

	-hpa
