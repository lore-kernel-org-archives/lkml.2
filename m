Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab1BVPWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 10:22:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753428Ab1BVPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 10:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <20110222140349.GA20708@kryptos.osrc.amd.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com> <20110222140349.GA20708@kryptos.osrc.amd.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Feb 2011 07:22:20 -0800
Message-ID: <AANLkTikESHHfjBqoLFOno6qQz-NXEAo-wBY5JEeAW61N@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
To: Borislav Petkov <bp@amd64.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 6:03 AM, Borislav Petkov <bp@amd64.org> wrote:
>
> I don't know whether this one is relevant or not but it is in fs/namei.c
> and it could mean vfs regression. I got the oops below after resuming
> from disk today, kernel is 38-rc5. However, it didn't happen yesterday
> on resume so it either is a glitch or a bug which is hard to reproduce.
> I'll run -rc6 to check.

It's relevant, and it's real, but it's fixed in -rc6 by commit 3abb17e82f08.

                      Linus
