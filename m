Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114Ab2ASCTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 21:19:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34002 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755770Ab2ASCTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 21:19:46 -0500
Message-ID: <4F177CF7.9070207@zytor.com>
Date: Wed, 18 Jan 2012 18:16:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
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
References: <20120116183730.GB21112@redhat.com>    <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>    <20120118015013.GR11715@one.firstfloor.org>    <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>    <20120118022217.GS11715@one.firstfloor.org>    <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>    <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>    <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>    <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>    <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>    <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com>    <4F1731C1.4050007@zytor.com>    <CA+55aFwnvOxT_K7HFOkjCbfDtYkAVkvF+a7r-0=T6gga_x9t-g@mail.gmail.com>    <4F1733DF.7040905@zytor.com>    <CA+55aFzrHaJUKgUCx1uaeuqcyzZuUwQLiGj9dP5D3m-xt6v2SA@mail.gmail.com> <c5552936e981cf649eb15d23bc79314c.squirrel@webmail.greenhost.nl>
In-Reply-To: <c5552936e981cf649eb15d23bc79314c.squirrel@webmail.greenhost.nl>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 05:45 PM, Indan Zupancic wrote:
> 
> For security reasons it should be impossible for userspace to set those bits
> themselves, otherwise the tracer can be easily fooled on an old kernel. That
> seems to be the case for the higher bits of eflags, so eflags would work. And
> the current code checks cs, also checking eflags would be very easy to add.
> 

I think this goes without saying, and isn't an issue for the options
currently on the table (including regset).

	-phpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

