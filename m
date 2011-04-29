Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab1D2OJM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:09:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46001 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758821Ab1D2OJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:09:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110428130427.06925753.sfr@canb.auug.org.au>
References: <20110428130427.06925753.sfr@canb.auug.org.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Fri, 29 Apr 2011 11:08:48 -0300
Message-ID: <BANLkTik-+E7+HXV_0ajpTzST2myBFuzm+Q@mail.gmail.com>
Subject: Re: large cross tree spelling fixes
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 12:04 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Linus,
>
> Next time you are tempted to take one of these, please resist. :-)
>
> It was not urgent, could have been (at least) broken up and sent to the
> respective maintainers, and caused many conflicts in linux-next (which
> either means unnecessary rebases/merges or you will see the conflicts
> next merge window).

Hi Stephen,

Sorry for the noise. I tried twice to go through each maintainer's
tree, but it didn't work. Then, as suggested by Ingo I sent directly
to Linus. Maybe the problem was the timing. I did sent shortly after
rc1, but because of some problems in the patch it was integrated only
after rc2.

I hope in next versions we don't have so many misspellings, so the
conflicts would not be as of now.


Lucas De Marchi
