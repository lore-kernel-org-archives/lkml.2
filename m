Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab1HYU2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 16:28:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41391 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753973Ab1HYU2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 16:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MUc3RSk8GTLRbsE=mY8o=K74B8PTFiVrhqCq9cCej92TA@mail.gmail.com>
References: <CAObL_7HLpji6xDcBAmwUXBQuahLLVzQXAfYz_gXufUqj_cDzeQ@mail.gmail.com>
 <0a627e9f49e26554cacdb4049e4c09fa94ca76b6.1314302910.git.luto@mit.edu> <CACqU3MUc3RSk8GTLRbsE=mY8o=K74B8PTFiVrhqCq9cCej92TA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 25 Aug 2011 13:28:29 -0700
Message-ID: <CA+55aFzDAhwZf4FRXA6nyd8G5-WHiRk43Ws1hmjjmUC6gY7cWQ@mail.gmail.com>
Subject: Re: [PATCH] x86-32: Fix boot with CONFIG_X86_INVD_BUG
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Andy Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 1:21 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> On Thu, Aug 25, 2011 at 4:10 PM, Andy Lutomirski <luto@mit.edu> wrote:
>>
>> Arnaud, can you test this?
>>
> All good.
>
> Tested-by: Arnaud Lacombe <lacombar@gmail.com>

Thanks guys. Applied and pushed out,

                        Linus
