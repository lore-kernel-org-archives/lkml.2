Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412Ab1LEUKj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 15:10:39 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:41235 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756257Ab1LEUKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 15:10:38 -0500
MIME-Version: 1.0
In-Reply-To: <20111205192701.GA1531@x4.trippels.de>
References: <20111124085040.GA1677@x4.trippels.de>
	<20111202230412.GB12057@homer.localdomain>
	<20111203092845.GA1520@x4.trippels.de>
	<CAPM=9tyjZc9waC_ZBygW9zh+Zq-Wb1X5Y6yfsCCMPYwpFVWOOg@mail.gmail.com>
	<20111203122900.GA1617@x4.trippels.de>
	<CAH3drwZDOpPuQ_G=LwTiNsR5BNyJTNr+VJU74E6nS5AbKyQH0A@mail.gmail.com>
	<20111204010200.GA1530@x4.trippels.de>
	<20111205171046.GA4342@homer.localdomain>
	<20111205181549.GA1612@x4.trippels.de>
	<20111205191116.GB4342@homer.localdomain>
	<20111205192701.GA1531@x4.trippels.de>
Date: Mon, 5 Dec 2011 22:10:34 +0200
X-Google-Sender-Auth: rJtWYcvZ1RLefE0RpLaFPhN1G9E
Message-ID: <CAOJsxLGCrNZnxZ70vpRGZ35GMK4MPDc4r6S=KTngQuL0eED94w@mail.gmail.com>
Subject: Re: WARNING: at mm/slub.c:3357, kernel BUG at mm/slub.c:3413
From: Pekka Enberg <penberg@kernel.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Jerome Glisse <j.glisse@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Christoph Lameter <cl@linux.com>, "Alex, Shi" <alex.shi@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Matt Mackall <mpm@selenic.com>, tj@kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 5, 2011 at 9:27 PM, Markus Trippelsdorf
<markus@trippelsdorf.de> wrote:
>> > Yes the patch finally fixes the issue for me (tested with 120 kexec
>> > iterations).
>> > Thanks Jerome!
>>
>> Can you do a kick run on the modified patch ?
>
> This one is also OK after ~60 iterations.

Jerome, could you please include a reference to this LKML thread for
context and attribution for Markus for reporting and following up to
get the issue fixed in the changelog?

                              Pekka
