Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2JPT1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:27:34 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:3078 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755838Ab2JPT1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:27:33 -0400
Date: Tue, 16 Oct 2012 19:27:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Avleen Vig <avleen@gmail.com>
cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reading /proc/slabinfo causes stalls
In-Reply-To: <CAMjP1K=vWLNqOjgwnvq9NfWU2af-M7+CFMtp9naraFO+Xmod6A@mail.gmail.com>
Message-ID: <0000013a6b0b92ae-fd5b1482-e870-4bbd-b5ac-de75b1b25177-000000@email.amazonses.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com> <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com> <0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
 <alpine.DEB.2.00.1210161147410.2910@chino.kir.corp.google.com> <0000013a6aee372f-add43c34-0cc1-4cdb-8ad1-730074b2b49b-000000@email.amazonses.com> <CAMjP1K=vWLNqOjgwnvq9NfWU2af-M7+CFMtp9naraFO+Xmod6A@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, Avleen Vig wrote:

> There were some concerns that it doesn't perform as well as SLAB on
> large hardware (we're almost always running >16G RAM, and regularly
> >96G RAM on things like memcache servers).
> If the performance pans out, SLUB would be great.

We have been using SLUB here for years with servers up to 256G RAM and
64 processors in both HPC and Enterprise environments.


