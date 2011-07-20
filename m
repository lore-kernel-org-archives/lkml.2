Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752296Ab1GTQEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 12:04:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752149Ab1GTQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 12:04:43 -0400
MIME-Version: 1.0
In-Reply-To: <1311173910.5345.94.camel@twins>
References: <20110707102107.GA16666@in.ibm.com> <1310036375.3282.509.camel@twins>
 <20110714103418.7ef25b68@kryten> <20110714143521.5fe4fab6@kryten>
 <1310649379.2586.273.camel@twins> <20110715104547.29c3c509@kryten>
 <1311024956.2309.22.camel@laptop> <20110719144451.79bc69ab@kryten>
 <1311070894.13765.180.camel@twins> <20110720201436.19e9689a@kryten>
 <1311158708.5345.12.camel@twins> <20110720221420.153b0830@kryten>
 <CA+55aFxzaaMj8OUaust90c_hYKzg8NpRfmX4SzJ9SMwXzg5ocA@mail.gmail.com> <1311173910.5345.94.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jul 2011 09:04:00 -0700
Message-ID: <CA+55aFxpH9-4rkH6CRXbjFCQMGNYGRMKgdgHUEthefQPumFKVg@mail.gmail.com>
Subject: Re: [regression] 3.0-rc boot failure -- bisected to cd4ea6ae3982
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Blanchard <anton@samba.org>, mahesh@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mingo@elte.hu, benh@kernel.crashing.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 7:58 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> Right, so we can either merge my scary patches now and have 3.0 boot on
> 16+ node machines (and risk breaking something), or delay them until
> 3.0.1 and have 16+ node machines suffer a little.

So how much impact does your scary patch have on machines that don't
have multiple nodes? If it's a "the code isn't even called by normal
machines" kind of setup, I don't think I care a lot.

                  Linus
