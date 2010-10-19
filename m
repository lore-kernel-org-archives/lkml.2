Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758249Ab0JSKrq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 06:47:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50558 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758213Ab0JSKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 06:47:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=hCOzqSks8kxDWjx/AOdcQUaP+VKyT7dMa4WLIds54+ngNDAd3H4Wgb9MbNJm4vvREu
         5ju2aB7qTShZ8th1xOqOscBsPoEerwpgO0PZfnHjzwY+0WqNA//k/80z1TcMk51PFC5f
         Hq9/zo0Cs/jE8pG3ymaQAqhnTDh2LUvCJo21w=
Subject: Re: [PATCH 0/6] Results of my work on memorystick subsystem
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <767911.16428.qm@web37608.mail.mud.yahoo.com>
References: <767911.16428.qm@web37608.mail.mud.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 12:47:37 +0200
Message-ID: <1287485257.13774.2.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 02:40 -0700, Alex Dubov wrote:
> --- On Mon, 18/10/10, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > 
> > But for mspro driver, it would be really hard for me to
> > split it.
> > I have rewritten a lot of code there.
> > Can't we just review the end result instead of the patch?
> > 
> > To split the patches, I pretty much need to rewrite the
> > whole thing once
> > gain.
> > I don't want to do that.
> > 
> 
> First, a useful citation (Documentation/HOWTO:548):
> "The Linux kernel community does not gladly accept large chunks of code
> dropped on it all at once.  The changes need to be properly introduced,
> discussed, and broken up into tiny, individual portions."
> 
> I actually attempted to submit a large "full rewrite" patch early on
> during development of one of my drivers. I was a sole developer and it was
> not even on a stable tree, as far as I can remember. Yet, that patch was
> dropped immediately with the above given reason.
> 
> And yes, I had to rewrite the whole thing again, this time in small steps.
Understood...

Fortunately, yesterday I have finished splitting all but jmicron patch,
and I finish it today, test patches for working (final state does work,
I tested), and resumbit.

Best regards,
	Maxim Levitsky



