Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730Ab0ERVLP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 17:11:15 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49291 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab0ERVLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 17:11:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=A0ospexnpw8pByecI1Xo9o8037qN7m1rVu1HJVykBOiBuep+izdoRZbqsc5pZ5kT6W
         xN6wBk2SbyEnHCSlGwl43Q/FyhnMmAdvBpLcHMVUnagcpWP/yW8E3wTWROQdft8VpasI
         X9iYPs8d6TGULbClPpZxjnOzQ/wmkmPBtC3j0=
Subject: Re: [tip:x86/fpu] x86: Add new static_cpu_has() function using
 alternatives
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
       tglx@linutronix.de, avi@redhat.com, linux-tip-commits@vger.kernel.org
In-Reply-To: <4BF2FF26.9050701@zytor.com>
References: <1273135546-29690-2-git-send-email-avi@redhat.com>
	 <tip-a3c8acd04376d604370dcb6cd2143c9c14078a50@git.kernel.org>
	 <1274213443.2485.3.camel@edumazet-laptop>  <4BF2FF26.9050701@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 May 2010 23:11:07 +0200
Message-ID: <1274217067.2485.9.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 18 mai 2010 à 13:57 -0700, H. Peter Anvin a écrit :
> On 05/18/2010 01:10 PM, Eric Dumazet wrote:
> > # gcc -v
> > Reading specs from /usr/lib/gcc/i386-redhat-linux/3.4.6/specs
> > Configured with: ../configure --prefix=/usr --mandir=/usr/share/man
> > --infodir=/usr/share/info --enable-shared --enable-threads=posix
> > --disable-checking --with-system-zlib --enable-__cxa_atexit
> > --disable-libunwind-exceptions --enable-java-awt=gtk
> > --host=i386-redhat-linux
> > Thread model: posix
> > gcc version 3.4.6 20060404 (Red Hat 3.4.6-10)
> 
> I just implemented a fallback for gcc 3, but the real question is to
> which degree we still care about gcc 3 support for x86 specifically
> (other architectures might have other needs, but this is x86-specific code.)
> 
> Lately the number of issues with gcc 3 support seems to have gone way
> up, and at some point we're going to have to cut it loose -- when would
> depend largely on what the usage case is; e.g. why are you, yourself,
> using gcc 3.4 to compile a state of the art kernel?

I use many different machines to compile kernels, and found this one
using gcc-3.4.6, but still running original 2.6.9.something RHEL
kernel ;)

For kernels I actually boot, I use gcc-4.5, 4.4.x, 4.3.x, 4.2.x, 4.1.2
(cross compiler)



