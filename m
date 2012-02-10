Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759038Ab2BJP4p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 10:56:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35946 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758193Ab2BJP4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 10:56:43 -0500
Message-ID: <4F353D65.7070705@zytor.com>
Date: Fri, 10 Feb 2012 07:53:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: "H.J. Lu" <hjl.tools@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
References: <20120116183730.GB21112@redhat.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>    <dac05d1da093cb86e2f654fbfe66dfce.squirrel@webmail.greenhost.nl>    <4F3007AD.50307@zytor.com>    <c85c91a49cc62132ad1ddb97748c26b9.squirrel@webmail.greenhost.nl>    <4F33110D.3050904@zytor.com>    <13c2c571244c71c2ba87451987805eed.squirrel@webmail.greenhost.nl>    <4F334B8C.2050005@zytor.com>    <CAMe9rOrf-DrgdwsnpX7pa=h1p9qSpqa9fwJAQJvjSzgR9MAB_w@mail.gmail.com>    <b3f79ce8b30e2985723eec1a3337317e.squirrel@webmail.greenhost.nl>    <4F346FB0.9070203@zytor.com>    <19ac5d5293110612dc17c514bc7e1ccd.squirrel@webmail.greenhost.nl> <cc95fcf4b1c28ee6f73e373d04593634.squirrel@webmail.greenhost.nl>
In-Reply-To: <cc95fcf4b1c28ee6f73e373d04593634.squirrel@webmail.greenhost.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2012 11:42 PM, Indan Zupancic wrote:>
> Patch implementing this below. It uses bit 3 for task mode and bit 5
> for syscall mode. Those bits are only valid if VIF is set. It increases
> the kernel size by around 50 bytes, 6 for a 32-bit kernel.
>
> Any objections?

#include <stdnak.h>

	-hpa

