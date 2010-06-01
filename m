Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab0FAPzm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 11:55:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34940 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab0FAPzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 11:55:41 -0400
Date: Tue, 1 Jun 2010 08:51:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mikael.starvik@axis.com
Subject: Re: Linux 2.6.35-rc1
In-Reply-To: <20100531094652.GI5051@axis.com>
Message-ID: <alpine.LFD.2.00.1006010850230.3637@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1005301356350.3986@i5.linux-foundation.org> <20100531094652.GI5051@axis.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 31 May 2010, Jesper Nilsson wrote:
> 
> I'm missing the CRIS tree changes, however, it seems to be me that
> screwed up here, my new computer was misconfigured for outgoing mail, so the
> request probably never reached you. Sorry about that.
> 
> Of the changes, the "mask_irq" one is still a candidate since it
> fixes a compile error.

Ok, I'll take them, since while it's late it's all in arch/cris. And if 
you broke it, you get to keep both pieces, and I can't really claim to 
care too deeply ;)

		Linus
