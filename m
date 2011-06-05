Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1FEUF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 16:05:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910Ab1FEUF0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 16:05:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=NsRAGURb8DMgTVURmjKLjRWJEYDS3DggrCAA255TjX6XZb4GQQrt7oRC1y6iO/K5bY
         FzMpgB0srtU7XZtN38z2jpE0CNcRPG5k753ZFlP3NXVvmaJ0U3KvCwD1DgiXx7E2mTJv
         HD4HpOvouqQbmPdRdZdaCtz9V0DKF0szy47D8=
MIME-Version: 1.0
In-Reply-To: <cover.1307292171.git.luto@mit.edu>
References: <cover.1307292171.git.luto@mit.edu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 5 Jun 2011 16:05:05 -0400
X-Google-Sender-Auth: F8L_A8VtVBXiDKssdcO4ztaqg1Q
Message-ID: <BANLkTin5Si3EPDWU++WAy0SsLmsHS5k_uw@mail.gmail.com>
Subject: Re: [PATCH v5 0/9] Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>, x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jesper Juhl <jj@chaosbits.net>, Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu, Andy Lutomirski <luto@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 1:50 PM, Andy Lutomirski <luto@mit.edu> wrote:

>  x86-64: Remove vsyscall number 3 (venosys)

Torsten Kaiser pointed out that this patch will break bisection due to
a typo.  So please don't apply this series as is.

If there are no further changes I need to make, I'll send out v6 with
the fix in a day or two (unless someone wants it sooner).

--Andy
