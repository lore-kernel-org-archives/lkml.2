Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab1EKQjB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 12:39:01 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756672Ab1EKQi4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 12:38:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=rvWBvlTpt7Hjg+GdlgAPMud/ZCok5aZESsKNhfKK7oSL8sGOyi0TKMyf42Vi60lNIl
         C+k4i6fIiMEoONUPC2HI2yVGot6M/kpie5DJlFIBcDVDwCcjXCV93qCxyou6xzvuaN7m
         lDYHnIPnCdlNaJeGMjfbLugMIqIeF0vofynx0=
MIME-Version: 1.0
In-Reply-To: <m1liydeuqs.fsf@fess.ebiederm.org>
References: <20110511140225.2c7e300f.sfr@canb.auug.org.au>
	<m1liydeuqs.fsf@fess.ebiederm.org>
Date: Wed, 11 May 2011 09:36:31 +0200
X-Google-Sender-Auth: XImlPg0IfurNoGhXftgQ71E6LUc
Message-ID: <BANLkTi=JRiafXn8SjxM9eKup3hvNHyB3rw@mail.gmail.com>
Subject: Re: linux-next: manual merge of the namespace tree with the m68k tree
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 06:17, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Stephen Rothwell <sfr@canb.auug.org.au> writes:
>> Today's linux-next merge of the namespace tree got a conflict in
>> arch/m68k/kernel/entry_mm.S between commit 55e1af1ab184 ("m68k: Merge mmu
>> and non-mmu versions of sys_call_table") from the m68k tree and commit
>> e975ee91dcc1 ("ns: Wire up the setns system call") from the namespace
>> tree.
>>
>> I just used the m68k version of that file and that should be all that is
>> necessary.
>
> Sounds good.  Gert asked me to check in that conflict (probably so
> bisects will continue to work), and if the commit id is right it looks
> like the m68k tree is seeing active development on that change right now.

I can add the syscall as soon as sys_setns() hits mainline.
That's what we usually do with new syscalls.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
