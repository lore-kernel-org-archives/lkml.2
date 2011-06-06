Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757668Ab1FFPwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:52:32 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35251 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab1FFPw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Z13tP7CQYx36mzSwpdq/1W8coSJYHtXxtacvOsDFcm9H3xc498tbR4nY6SsCiu2Ml6
         aUKzFlHnZVWMAUunSp9PIMzykFU/IB/N0IWyw58kI599B+H2k+G/ShE0pKvqZETlGEDd
         qUeUFU8lVnCdTDi9xh0oM9/hEUToTrq5kkOPk=
MIME-Version: 1.0
In-Reply-To: <20110605082100.GA18151@leaf>
References: <20110605082100.GA18151@leaf>
Date: Mon, 6 Jun 2011 23:52:29 +0800
Message-ID: <BANLkTi=_HKA+Jwi3zwSr+df+7dMnGC+zGQ@mail.gmail.com>
Subject: Re: [PATCH] Disable CONFIG_CONSTRUCTORS when not needed by CONFIG_GCOV_KERNEL
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Sam Ravnborg <sam@ravnborg.org>,
        Jeff Dike <jdike@addtoit.com>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Li Wei <W.Li@sun.com>,
        Michael Ellerman <michaele@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Heiko Carstens <heicars2@linux.vnet.ibm.com>,
        Martin Schwidefsky <mschwid2@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 5, 2011 at 4:21 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> CONFIG_CONSTRUCTORS controls support for running constructor functions
> at kernel init time.  According to commit
> b99b87f70c7785ab1e253c6220f4b0b57ce3a7f7, gcov (CONFIG_GCOV_KERNEL)
> needs this.  However, CONFIG_CONSTRUCTORS currently defaults to y, with
> no option to disable it, and CONFIG_GCOV_KERNEL depends on it.  Instead,
> default it to n and have CONFIG_GCOV_KERNEL select it, so that the
> normal case of CONFIG_GCOV_KERNEL=n will result in
> CONFIG_CONSTRUCTORS=n.
>
> Observed in the short list of =y values in a minimal kernel
> configuration.
>
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>

Yeah, this is reasonable, so,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>

Thanks!
