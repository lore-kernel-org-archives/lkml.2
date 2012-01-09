Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2AIPAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 10:00:25 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:47539 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060Ab2AIPAY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 10:00:24 -0500
MIME-Version: 1.0
In-Reply-To: <1326118036.6755.101.camel@sauron.fi.intel.com>
References: <1326118036.6755.101.camel@sauron.fi.intel.com>
Date: Mon, 9 Jan 2012 16:00:23 +0100
Message-ID: <CAFLxGvy7MPfBp=prAqELwcWuHFjB0qnNrTRzmoGBN39==G76Dg@mail.gmail.com>
Subject: Re: [GIT PULL] UBI/UBIFS changes for v3.3
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: artem.bityutskiy@linux.intel.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 9, 2012 at 3:07 PM, Artem Bityutskiy
<artem.bityutskiy@linux.intel.com> wrote:
> Hi Linus,
>
> please pull UBI and UBIFS changes for v3.3.
>
> The following changes since commit cfcfc9eca2bcbd26a8e206baeb005b055dbf8e37:
>
>  Linux 3.2-rc2 (2011-11-15 15:02:59 -0200)
>
> are available in the git repository at:
>  git://git.infradead.org/ubifs-2.6.git linux-next
>
> Artem Bityutskiy (1):
>      UBI: fix use-after-free on error path
>
> Bhavesh Parekh (1):
>      UBI: fix missing scrub when there is a bit-flip
>
> Thomas Meyer (1):
>      UBIFS: Use kmemdup rather than duplicating its implementation
>

Where is "ubi: Make vid_hdr non-static"?
http://marc.info/?l=linux-kernel&m=132456978023418

-- 
Thanks,
//richard
