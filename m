Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1KAXX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:23:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36957 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754400Ab1KAXXZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:23:25 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.00.1111020835080.11087@tundra.namei.org>
References: <1319672956-17114-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.00.1111020735080.11087@tundra.namei.org>
	<CAGXu5jJUZoKksT3AY3fF9Nt66FL+6mDbmUnYVGVChpeV=UT_2g@mail.gmail.com>
	<alpine.LRH.2.00.1111020835080.11087@tundra.namei.org>
Date: Tue, 1 Nov 2011 16:23:24 -0700
X-Google-Sender-Auth: LMVw7-wwX4c-qU_2vUlLbo0Q3GI
Message-ID: <CAGXu5j+KxkASVzo5-i_47gjpAmK1Qp=yjRmLbGrotK4da7iMOQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/3] security: Yama LSM
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 1, 2011 at 2:37 PM, James Morris <jmorris@namei.org> wrote:
> On Tue, 1 Nov 2011, Kees Cook wrote:
>
>> > We probably need to flesh out criteria for inclusion in Yama and document
>> > it.
>>
>> What's the best way for me to help with that documentation?
>
> Perhaps post a basic document for review.  It doesn't have to be a novel.

I've sent this now. We can expand it further if needed.

> One thing I'd like to see is making it clear that if a feature is nacked
> by a core maintainer, Yama is not a means to bypass that nack.  That
> maintainer will need to ack it as part of Yama, too.

At the same time, Yama isn't intended to be an endless dumping ground
for all random things. It's intended to be a place to put DAC
extensions that make sense for general system hardening. I can clarify
that further in the Yama documentation, if that's not already clear.

-Kees

-- 
Kees Cook
ChromeOS Security
