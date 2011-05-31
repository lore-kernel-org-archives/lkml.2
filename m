Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab1EaUQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:16:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43872 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753371Ab1EaUQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:16:29 -0400
Message-ID: <4DE54C66.10106@zytor.com>
Date: Tue, 31 May 2011 13:15:34 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Dan Rosenberg <drosenberg@vsecurity.com>, Matthew Garrett <mjg@redhat.com>,
        Tony Luck <tony.luck@gmail.com>, linux-kernel@vger.kernel.org,
        kees.cook@canonical.com, davej@redhat.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, eranian@google.com,
        penberg@kernel.org, davem@davemloft.net,
        Arjan van de Ven <arjan@infradead.org>, Valdis.Kletnieks@vt.edu,
        Andrew Morton <akpm@linux-foundation.org>, pageexec@freemail.hu,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
References: <1306269105.21443.20.camel@dan> <1306442367.2279.25.camel@dan> <20110531165252.GB8971@srcf.ucam.org> <4DE5360D.5070809@zytor.com> <20110531185122.GA11998@srcf.ucam.org> <1306868609.6317.25.camel@dan> <20110531195551.GC26970@elte.hu>
In-Reply-To: <20110531195551.GC26970@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 12:55 PM, Ingo Molnar wrote:
> 
> So ... could you *please* not shelf this idea just because people 
> used lkml for what it was invented: argued with each other rather 
> forcefully? :-)
> 

The real issue is that if it can be (semi)trivially bypassed, then there
may not be much reason to do it.

Other than that, Ingo's idea at least have the merit that it would break
only older bootloaders doing things wrong.

	-hpa
