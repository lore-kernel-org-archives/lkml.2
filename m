Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1GTOks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:40:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35553 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969Ab1GTOkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:40:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110720221420.153b0830@kryten>
References: <20110707102107.GA16666@in.ibm.com> <1310036375.3282.509.camel@twins>
 <20110714103418.7ef25b68@kryten> <20110714143521.5fe4fab6@kryten>
 <1310649379.2586.273.camel@twins> <20110715104547.29c3c509@kryten>
 <1311024956.2309.22.camel@laptop> <20110719144451.79bc69ab@kryten>
 <1311070894.13765.180.camel@twins> <20110720201436.19e9689a@kryten>
 <1311158708.5345.12.camel@twins> <20110720221420.153b0830@kryten>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jul 2011 07:40:23 -0700
Message-ID: <CA+55aFxzaaMj8OUaust90c_hYKzg8NpRfmX4SzJ9SMwXzg5ocA@mail.gmail.com>
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
To: Anton Blanchard <anton@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mahesh@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mingo@elte.hu, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 5:14 AM, Anton Blanchard <anton@samba.org> wrote:
>
>> So with that fix the patch makes the machine happy again?
>
> Yes, the machine looks fine with the patches applied. Thanks!

Ok, so what's the situation for 3.0 (I'm waiting for some RCU
resolution now)? Anton's patch may be small, but that's just the tiny
fixup patch to Peter's much scarier one ;)

                            Linus
