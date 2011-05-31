Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab1EaNy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 09:54:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55115 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab1EaNy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 09:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=w+zxpj5FSCKG2Bncv4Ou3zRkT1Sgk4Ofo1Op8jrdnL2BR78ELcQIJ2ABjLnQSUbM3g
         Ohw4LZ6FbOnrWJciQF+m3pFTxKEx85HBLe2BTjbJVggHcgnZz0M8B0j8AiwJBmzVxFgI
         aX2wq8YUyuE4GD8RrAgCBCbxSvXJ3IvuYDwD4=
MIME-Version: 1.0
In-Reply-To: <20110531134549.GA15598@elte.hu>
References: <cover.1306847455.git.luto@mit.edu> <20110531134549.GA15598@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Tue, 31 May 2011 09:54:06 -0400
X-Google-Sender-Auth: Fsyw5EREp03AUXh8eSlAyyU1gyw
Message-ID: <BANLkTimCykPmQOyQ4Soi9Q9uVdkHZcWtVA@mail.gmail.com>
Subject: Re: [PATCH v3 00/10] Remove syscall instructions at fixed addresses
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 31, 2011 at 9:45 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andy Lutomirski <luto@mit.edu> wrote:
>
>> Patch 1 is just a bugfix from the last vdso series.
>> The bug should be harmless but it's pretty dumb.  This is almost
>> certainly 3.0 material.
>
> Please make the patches apply cleanly to the latest x86 tree:
>
>  http://people.redhat.com/mingo/tip.git/README
>
> they currently don't - patch #4 does not apply.

The rebase applies with git mergetool's help without manual intervention.

I'll compile and test the rebased series before I send it out as v4
(should be about an hour).

--Andy

>
> Thanks,
>
>        Ingo
>
