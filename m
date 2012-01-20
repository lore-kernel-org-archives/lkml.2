Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522Ab2AUABy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 19:01:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43432 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab2AUABv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 19:01:51 -0500
References: <20120116183730.GB21112@redhat.com> <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com> <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com> <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl> <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com> <CA+55aFwMd8MMrcfG5f0zg=qjrBzUhgY1HgJx6QFcnpMQsW1PNg@mail.gmail.com> <4F1731C1.4050007@zytor.com> <4F1733DF.7040905@zytor.com> <4F1737C9.3070905@zytor.com> <CAB=4xhqW8RK2UpU5PPjSQo3nZYt8oZkaBf1VEhX37tbMVrAigg@mail.gmail.com> <4F173F48.2070604@zytor.com> <CA+55aFw3kv_JRsSCQEf6fQd0gX939MuoevDxFtcXkPY+bmyjtA@mail.gmail.com> <4F176605.5020101@zytor.com> <CAK1hOcManWsEvjS2xxtfGTKx=JLPvO2sBkWU-xQP+medV=rbAA@mail.gmail.com> <CAB=4xhqFYdU3s_NQkgdzVVG1r3vGDb=qPewPRFTrJ1B_eiEVDA@mail.gmail.com> <4F19EDAF.2000109@zytor.com> <d8be1991e82ec686433c5c6e255c2bd9.squirrel@webmail.greenhost.nl> <CAB=4xhqVQXtQnsjfWMGdd+rOsO+PyHd-OkC75cXFHnunzeyuAQ@mail.gmail.com>
User-Agent: K-9 Mail for Android
In-Reply-To: <CAB=4xhqVQXtQnsjfWMGdd+rOsO+PyHd-OkC75cXFHnunzeyuAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
From: "hpanvin@gmail.com" <hpa@zytor.com>
Date: Fri, 20 Jan 2012 15:58:21 -0800
To: Roland McGrath <mcgrathr@google.com>, Indan Zupancic <indan@nul.nu>
CC: Denys Vlasenko <vda.linux@googlemail.com>,
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
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com
Message-ID: <529e70ab-8a37-478a-8ba1-af5f5b9156e4@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus claims it does break.

Roland McGrath <mcgrathr@google.com> wrote:

>On Fri, Jan 20, 2012 at 3:49 PM, Indan Zupancic <indan@nul.nu> wrote:
>> It's a lot easier for existing code to add an extra cs check than to
>use
>
>The issue is whether showing fictitious high bits of %cs as set will
>break
>existing applications (debuggers, etc.) that look at it and think that
>it's
>nothing but the hardware state zero-extended, as it is today.

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
