Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab1CNMiW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 08:38:22 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55794 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab1CNMiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 08:38:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=W3zaLlEyysLQMsfVraklL4gvIlyfNwWRaF4leCczTsyU6WI1y3WC5q6tVPh01GH2jE
         mszJOjOu3Xlz4Uu3/XHiuiEXXAB93lBGdyhy65FPvjwZcsCbHGKOWnHAHO0wZ5GVsOKm
         UW47sRNwtMSBYRfSdRwIewHt1SvMMxzXs/Q8g=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <4D7E166C0200007800036451@vpn.id2.novell.com>
References: <AANLkTinDTyupNgZR-0izCWrpwOnE1wEcubn+M3o=Mgy2@mail.gmail.com>
	<4D7E095802000078000363D5@vpn.id2.novell.com>
	<AANLkTikUKE4xzf-NJtK3vMCQmNEYiAXZzi2vMZs9Zy4W@mail.gmail.com>
	<AANLkTimmi7A6cXo8BCHWtBDmauZD4_-dNjThpn1J9DkW@mail.gmail.com>
	<4D7E166C0200007800036451@vpn.id2.novell.com>
Date: Mon, 14 Mar 2011 13:38:19 +0100
Message-ID: <AANLkTikQ1BZr0Q5TSsFafxXf=YJrN0pdXpDaStB8doqn@mail.gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "H.J. Lu" <hjl.tools@gmail.com>
Cc: Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        amodra@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        binutils <binutils@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H.J.,

against which binutils source-code is your patch?
I tried binutils-from-git (last commit 83e680a: "daily update") and
your binutils-2.21.51.0.7.

None of them have a gas/testsuite/gas/i386/bad-size.d file, so...

diff --git a/gas/testsuite/gas/i386/bad-size.d
b/gas/testsuite/gas/i386/bad-size.d
index be9655e..0bcf381 100644
--- a/gas/testsuite/gas/i386/bad-size.d
+++ b/gas/testsuite/gas/i386/bad-size.d
@@ -1,7 +1,7 @@
 #as: --size-check=warning
 #objdump: -dw
 #name: Check bad size directive
-#error-output: bad-size.err
+#error-output: bad-size.warn

 .*: +file format .*

... cannot be applied.

Also, there are no gas/ChangeLog.x86 and gas/testsuite/ChangeLog.x86
files (but w/o *.x86).

Can you resend a proper patch against binutils-from-upstream?
Thanks.

Regards,
- Sedat -
