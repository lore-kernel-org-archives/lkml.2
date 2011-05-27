Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab1E0A0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 20:26:14 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:63345 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab1E0A0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 20:26:13 -0400
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        torvalds@linux-foundation.org, adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        Ingo Molnar <mingo@elte.hu>, pageexec@freemail.hu
In-Reply-To: <4DDED4ED.7020806@zytor.com>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
	 <4DDED4ED.7020806@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 May 2011 20:26:03 -0400
Message-ID: <1306455963.1984.5.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-05-26 at 15:32 -0700, H. Peter Anvin wrote:
> On 05/26/2011 03:18 PM, Rafael J. Wysocki wrote:
> > 
> > Well, as far as I can tell, this feature is going to break hibernation on
> > both x86_32 and x86_64 at the moment, unless you can guarantee that the
> > randomized kernel location will be the same for both the boot and the target
> > kernels.
> > 
> 
> Obviously we can't and we don't.  I'm a bit surprised at that
> constraint... how can that constraint not break things like kernels of
> slightly different size?
> 
> 	-hpa

Am I understanding it correctly that hibernation is currently operating
under a possibly false assumption?  If it's the case that hibernation
should be saving the physical address at which the kernel was previously
loaded and restoring it there regardless of randomization, it would
certainly help me out if someone familiar with the code could take a
stab at that.

Otherwise, any thoughts on a potential solution?

Thanks,
Dan

