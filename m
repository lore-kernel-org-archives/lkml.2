Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab2AZOFe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:05:34 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37008 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab2AZOFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:05:32 -0500
MIME-Version: 1.0
In-Reply-To: <20120126114741.GG18613@jl-vm1.vm.bytemark.co.uk>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <20120125193635.GA30311@redhat.com> <201201260032.57937.vda.linux@googlemail.com>
 <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <20120126010858.GD18613@jl-vm1.vm.bytemark.co.uk> <88753c7d600bee39c06bbda32b08daae.squirrel@webmail.greenhost.nl>
 <20120126103157.GE18613@jl-vm1.vm.bytemark.co.uk> <6cc0a81f9f84af80bd66bc44a03c8c0b.squirrel@webmail.greenhost.nl>
 <20120126114741.GG18613@jl-vm1.vm.bytemark.co.uk>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Thu, 26 Jan 2012 15:05:10 +0100
Message-ID: <CAK1hOcNXLO+TdFstZDX9bQyEMga=5A+4G4Sk6Te=PWe3+Q=+2Q@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Jamie Lokier <jamie@shareable.org>
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Andrew Lutomirski <luto@mit.edu>,
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 12:47 PM, Jamie Lokier <jamie@shareable.org> wrote:
> Indan Zupancic wrote:
> Denys, would you be interested in further refactoring strace to use a
> "libsystrace" sort of thing which abstracts the detail of archs,
> tracing (and maybe syscall argument layout) away from the printing and
> user-interface, for strace's use and other users?  I would be happy to
> help with that and keep strace's non-Linux support as well (if there's
> any way to test the latter...)  I seem to be going in the direction of
> a library like that anyway for another project.

It might make sense to do this.
Design of this library would depend on the needs
of those other projects. Where can I see their code?

-- 
vda
