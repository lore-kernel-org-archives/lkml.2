Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2DPUeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 16:34:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60403 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2DPUeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 16:34:08 -0400
MIME-Version: 1.0
In-Reply-To: <20120416202813.GB4678@gmail.com>
References: <20120416091719.GA4113@gmail.com> <4F8C76A0.2050601@xenotime.net>
 <1334604911.2726.2.camel@joe2Laptop> <20120416202813.GB4678@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Apr 2012 13:33:46 -0700
X-Google-Sender-Auth: odk-1guiXq7ZVIvhAbwV25E45rs
Message-ID: <CA+55aFz6FFQAyx5E10CpwC1H+pOYqqLwQnkgUBYDp_zjH4t2pw@mail.gmail.com>
Subject: Re: [PATCH] checkpatch: revert --strict test for net/ and drivers/net
 block comment style
To: Ingo Molnar <mingo@kernel.org>
Cc: Joe Perches <joe@perches.com>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 1:28 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Joe Perches <joe@perches.com> wrote:
>
>> Revert the --strict test for the old preferred block
>> comment style in drivers/net and net/
>
> Emphatic NAK.

Ingo, I don't think you understood. That test reverts the thing you
wanted reverted wrt the block comments.

It does not revert the *other* things in that patch (testing for empty
braces etc).

So Joe's patch seems to be exactly what you asked for,

                      Linus
