Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2DOKii (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 06:38:38 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:38723 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366Ab2DOKih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 06:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
References: <1334483226.20721.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Date: Sun, 15 Apr 2012 12:38:36 +0200
Message-ID: <CAFLxGvwJCMoiXFn3OgwiX+B50FTzGZmo6eG3xQ1KaPsEVZVA1g@mail.gmail.com>
Subject: Re: [NEW]: Introducing shrink_all_memory from user space
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: PINTU KUMAR <pintu_agarwal@yahoo.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "pintu.k@samsung.com" <pintu.k@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:47 AM, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
> Please provide your valuable feedback and suggestion.

This is fundamentally flawed.
You're assuming that only one program will use this interface.
Linux is a multi/user-tasking system

If we expose it to user space *every* program/user will try too free
memory such that it
can use more.
Can you see the problem?

-- 
Thanks,
//richard
