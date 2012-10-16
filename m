Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2JPSza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:55:30 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:44359 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755681Ab2JPSz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:55:29 -0400
Date: Tue, 16 Oct 2012 18:55:28 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@kernel.org>, Avleen Vig <avleen@gmail.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Reading /proc/slabinfo causes stalls
In-Reply-To: <alpine.DEB.2.00.1210161147410.2910@chino.kir.corp.google.com>
Message-ID: <0000013a6aee372f-add43c34-0cc1-4cdb-8ad1-730074b2b49b-000000@email.amazonses.com>
References: <CAMjP1K=WV=AJ=paz7uBJ2X0FnOX6Cf-HipWsFjLxicXGbvL6Sw@mail.gmail.com> <CAOJsxLF2VJRRu_i2aCARwiw6knyrwL1HpZ1zGOASP133fNxv8Q@mail.gmail.com> <0000013a6ad64c95-106bab18-5a15-4c85-bae9-5527aa52f661-000000@email.amazonses.com>
 <alpine.DEB.2.00.1210161147410.2910@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2012, David Rientjes wrote:

> Or convert slab_mutex to be a rwlock?

The RT folks just converted it to a mutex.... ;-)

