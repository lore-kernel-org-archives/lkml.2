Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617Ab1G1E75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 00:59:57 -0400
Received: from mail.perches.com ([173.55.12.10]:4347 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab1G1E7u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 00:59:50 -0400
Subject: Re: broken checkpatch signature checking
From: Joe Perches <joe@perches.com>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110728044924.GA21655@redhat.com>
References: <20110728043327.GA21448@redhat.com>
	 <1311828102.10042.1.camel@Joe-Laptop>  <20110728044924.GA21655@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jul 2011 21:59:47 -0700
Message-ID: <1311829187.10042.4.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-07-28 at 00:49 -0400, Dave Jones wrote:
> On Wed, Jul 27, 2011 at 09:41:42PM -0700, Joe Perches wrote:
>  > On Thu, 2011-07-28 at 00:33 -0400, Dave Jones wrote:
>  > > The signature checking patches in commit 2011247550 have broken one use-case for me.
>  > > I pipe the git-commits mailing list to it and skim the summary once a day[*]
>  > > Because git indents its changelogs, every single commit is now warning
>  > > with this..
>  > > WARNING: Do not use whitespace before Signed-off-by:
>  > Maybe you could use --ignore=BAD_SIGN_OFF for this reviewing?
> Ok, that works for me.  I guess I should add all the whitespace ignores while I'm at it.

or maybe add --ignore-all-space to git log


