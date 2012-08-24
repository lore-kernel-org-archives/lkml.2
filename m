Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030587Ab2HXVEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 17:04:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54478 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030446Ab2HXVEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 17:04:21 -0400
Date: Fri, 24 Aug 2012 14:04:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Matt Porter <mporter@kernel.crashing.org>
Subject: Re: [PATCH] rapidio: apply RX/TX enable to active switch ports only
Message-Id: <20120824140419.2b3a9623.akpm@linux-foundation.org>
In-Reply-To: <1345559035-25879-2-git-send-email-alexandre.bounine@idt.com>
References: <1345559035-25879-1-git-send-email-alexandre.bounine@idt.com>
	<1345559035-25879-2-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012 10:23:55 -0400
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Modify RIO enumeration to apply RX/TX enable operations only to active
> switch ports. This will leave inactive ports in condition consistent with
> their state.

It's unclear (to me) what the effects of this are.  Does it fix some
user-visible malfunction?  Or is it just some nice-to-have thing?  Or
what?

> This patch is applicable to kernel versions starting from v2.6.35.

Is that a recommendation that such a backport be performed?  If so,
please provide the reasoning.
