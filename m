Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856Ab1HITzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:55:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39889 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751981Ab1HITzQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:55:16 -0400
MIME-Version: 1.0
In-Reply-To: <62d52fb8ef3225691220070b6d069f9c1838f5d0.1312908294.git.luto@mit.edu>
References: <CAObL_7HL7SwCfXsD3dPesE4cU-nmoMCRVCP6u2Mn8efo7EG5Zg@mail.gmail.com>
 <62d52fb8ef3225691220070b6d069f9c1838f5d0.1312908294.git.luto@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Aug 2011 12:54:20 -0700
Message-ID: <CA+55aFxFiTUUvi4bexM5sP5tYst+ae1bQTAvep43NLXpV8FUBA@mail.gmail.com>
Subject: Re: [RFC] x86-64: Add vsyscall=emulate|native|none option
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        lueckintel@yahoo.com, kimwooyoung@gmail.com,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 9, 2011 at 9:47 AM, Andy Lutomirski <luto@mit.edu> wrote:
> vsyscall=native makes vsyscalls as fast as syscalls and makes pin
> and DynamoRIO work.  vsyscall=emulate (default) preserves current
> behavior, and vsyscall=none is good for paranoid people who don't
> need their boxes to work reliably.

I think at this stage we should do this, but additionally just change
the default to 'native', avoiding the incompatibilities.

                            Linus
