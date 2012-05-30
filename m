Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab2E3DUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:20:09 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:64774 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab2E3DUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:20:07 -0400
MIME-Version: 1.0
In-Reply-To: <4FC58EFE.2070705@zytor.com>
References: <201205292325.q4TNPBPw007366@terminus.zytor.com>
 <CA+55aFyjcbaRcK5yfi-xLc2W+AAk0EAY9fhNOc+-_uQdDzck6w@mail.gmail.com> <4FC58EFE.2070705@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 29 May 2012 20:19:45 -0700
X-Google-Sender-Auth: -zrKgZpFJuk5BMfxqePCtQiu8Yk
Message-ID: <CA+55aFyNJLYyC71rpNE+6kax+j_6ybN=GE_4fG1YKH2OevkRTg@mail.gmail.com>
Subject: Re: [GIT PULL] x86 trampoline rework for 3.5
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 8:07 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> Sorry, you're right.  The version with three patterns is correct.

Ok. So I pushed out my merge with that. I think that with the
x86-relocs thing in scripts/.gitignore it then ends up being the same
as yours.

I didn't see any git silent mis-merges, though. The fact that that
relocs.c file had come in two different ways did make for a more
interesting merge, since it didn't have any common ancestry - just two
different original versions. But git seemed to do the right thing, and
marked where they differed.

                   Linus
