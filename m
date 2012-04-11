Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481Ab2DKXUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:20:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60504 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab2DKXUv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
References: <1334186326-22649-1-git-send-email-grant.likely@secretlab.ca>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 11 Apr 2012 17:20:30 -0600
X-Google-Sender-Auth: ROul-ZxUKDhQhPjpgl0gkWrlgOo
Message-ID: <CACxGe6tYXfJ9JZkJ9_bVE8FTg8TZLo_V50wAy4Nf=4yObF71tQ@mail.gmail.com>
Subject: Re: irq_domain fixes for v3.4-rc2
To: linux-kernel@vger.kernel.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, missed out the cc's.

g.

On Wed, Apr 11, 2012 at 5:18 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> Hi Ben,
>
> Here are the fixes I'm proposing for the irq_domain issues seen on
> powermac.  I had originally only intended to remove the
> irq_virq_count, but I already had the hint and slow path removal
> patches written and reviewed, and removing them reduces the number of
> failure paths, and simplifies the code quite a bit.
>
> I've pushed this out to the following branch for testing:
>
> git://git.secretlab.ca/git/linux-2.6 irqdomain/test
>
> It has been boot tested on ARM, but not powerpc.  This series of three
> patches applies on top of the existing irqdomain/merge branch on my
> git server:
>
> git://git.secretlab.ca/git/linux-2.6 irqdomain/merge
>
> Can you test on your powermac?
>
> Thanks,
> g.
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
