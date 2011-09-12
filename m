Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1ILSQH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:16:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33851 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab1ILSQD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:16:03 -0400
MIME-Version: 1.0
In-Reply-To: <20110912144717.GB2555@redhat.com>
References: <94c0e3275b0bf7d2cad8e7909da1482a867e7bc6.1314725877.git.jbaron@redhat.com>
 <20110908165230.a7505321.akpm@linux-foundation.org> <1315534396.11939.10.camel@Joe-Laptop>
 <20110908204200.6cf7abc2.akpm@linux-foundation.org> <1315540963.11939.12.camel@Joe-Laptop>
 <CAO+b5-oOHXEhnA+zpwA9GR7k1TX3Wn6XuOdc3TB4MPNiSpskiw@mail.gmail.com>
 <CAJfuBxx=r_P7em_naUN_c96A++V4v6nfd8B_V2dppRag-z_qwg@mail.gmail.com>
 <1315602252.23777.5.camel@Joe-Laptop> <CAJfuBxwtefLyJcz1EbKvsGJ+XMtJiRW7A3Yy+wHXgL3GpUXbSg@mail.gmail.com>
 <1315607527.23777.21.camel@Joe-Laptop> <20110912144717.GB2555@redhat.com>
From: Jim Cromie <jim.cromie@gmail.com>
Date: Mon, 12 Sep 2011 12:15:32 -0600
Message-ID: <CAJfuBxysYL+Co3vDnWKYX_nJHaFoq9MJ9o4DP1Djwh84nm7HJA@mail.gmail.com>
Subject: Re: [PATCH 1/4] dynamic_debug: consolidate repetitive struct _ddebug
 descriptor definitions
To: Jason Baron <jbaron@redhat.com>
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
        gregkh@suse.de, Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> No real idea why it's aligned(8).  Jason?
>>
>
> I think when I first implemented it, I noticed that subsystems that did
> similar things, set aligned(8) in include/asm-generic/vmlinux.lds.h. For
> example, FTRACE_EVENTS() sets ALIGN(8)...I know that not a great reason
> thouh :( Don't remember if I tried ALIGN(4), but if it saves space, we
> can look at it...
>

I tried it here on 32bit (on 586 class machine), it blew up.
I imagine it could be made to work, but its not a gimme.

> Also, as I mentioned before, we probably need an extra array of pointers into
> the dynamic debug structures. see: https://lkml.org/lkml/2011/1/26/463.
>

I'll try it again, once this happens.

> thanks,
>
> -Jason
>
