Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab0LQG2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 01:28:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49418 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab0LQG2g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 01:28:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kCiuSATsSxgarbmTA8bIfL67aZtTdzpUUr8m2zUCbObiWE1IvdLGEljDIEqnfcsnlJ
         mUeU/N1aEQjJDvSfgH25V0tly90avtLGaVYcBmNXVLPNL6TyMACcH0WAfdf9cCJ1gMzt
         3Ztigf3ly4fi8IAvlYEmeNk+Z+LeUwFWAbqi8=
MIME-Version: 1.0
In-Reply-To: <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
	<AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
Date: Thu, 16 Dec 2010 22:28:35 -0800
Message-ID: <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
Subject: Re: [concept & "good taste" review] persistent store
From: Tony Luck <tony.luck@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        tglx@linutronix.de, mingo@elte.hu, greg@kroah.com,
        akpm@linux-foundation.org, ying.huang@intel.com,
        Borislav Petkov <bp@alien8.de>, David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 5:57 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Then I hit the
>
>        /* Don't dump oopses to persistent store */
>        if (reason == KMSG_DUMP_OOPS)
>                return;
>
> and I'm like "ok, this is just stupid".
>
> The _only_ valid reason for persistent storage is for things like
> oopses that kill the machine.

Maybe I misunderstood what "KMSG_DUMP_OOPS" meant ... it
looked to me like this code is used for non-fatal OOPsen - ones
that will be logged to /var/log/messages.

You are right that the whole point of this is to save data from
fatal errors ... if I'm not doing that, then I'm happy to change
things until I achieve that goal.

-Tony
