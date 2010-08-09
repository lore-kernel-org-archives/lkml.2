Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925Ab0HIUTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 16:19:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756390Ab0HIUTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 16:19:53 -0400
MIME-Version: 1.0
In-Reply-To: <20100809200945.GA1595@arch.tripp.de>
References: <4C596D21.4080101@kernel.org> <AANLkTimfmJsUSMw9AuOo3sf_n8hUUMDqvAD13FhZZans@mail.gmail.com> 
	<20100809200945.GA1595@arch.tripp.de>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 Aug 2010 13:18:57 -0700
Message-ID: <AANLkTikS=N7sW0eJJRRJrTXMuihuCmxRP=TFmYi0=7Et@mail.gmail.com>
Subject: Re: [GIT PULL] workqueue for v2.6.36
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Jens Axboe <axboe@kernel.dk>,
        Daniel Walker <dwalker@codeaurora.org>, Jeff Garzik <jeff@garzik.org>,
        David Howells <dhowells@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Suresh Jayaraman <sjayaraman@suse.de>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Steve French <sfrench@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andy Walls <awalls@radix.net>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 9, 2010 at 1:09 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
> On Mon, Aug 09, 2010 at 01:05:31PM -0700, Linus Torvalds wrote:
>>
>> I'll bisect it all the way, but thought I'd let you know.
>
> No need to, it's already fixed:
> http://lkml.org/lkml/2010/8/9/94

Right you are. That patch fixes it for me too.

Tejun, please send me a pull request for the fixes (or patches). I
hate picking up patches that haven't been explicitly sent to me.

                                    Linus
