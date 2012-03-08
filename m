Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab2CHUQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:16:16 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63767 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758238Ab2CHUQP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:16:15 -0500
MIME-Version: 1.0
In-Reply-To: <20120308200729.GL21812@moon>
References: <20120308165112.GF21812@moon> <CAGXu5j+4RRGjzVxLSyz0CZCNMj4dPOxJp3pYGSN_sXFsiMhUaQ@mail.gmail.com>
 <20120308194008.GJ21812@moon> <CALCETrXpQOpAN64gfG-=iyXXy4Tid=9FyKVrT2grQxRgNPC-fg@mail.gmail.com>
 <20120308200729.GL21812@moon>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 8 Mar 2012 12:15:55 -0800
Message-ID: <CALCETrXc9Etit+DUuxKtUwRKmqbwbE5vhDNYWgs0ijEesY8cUA@mail.gmail.com>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 12:07 PM, Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> On Thu, Mar 08, 2012 at 12:02:50PM -0800, Andy Lutomirski wrote:
>> >
>> > I can do that if Andrew agree.
>>
>> I'm a bit lost.  nnp updates the MNT_NOSUID checks, not the MNT_NOEXEC
>> checks.  (And the effects of the two flags is different in selinux for
>> historical reasons.)  I'm sure I'm missing something.
>>
>
> Andy, I've no idea what nnp is ;) I was only about to gather those
> ISREG/MNT_NOEXEC to one helper since we indeed have a few places in
> kernel which do same thing in open-coded manner.

Am I not the Andrew you were referring to?

--Andy
