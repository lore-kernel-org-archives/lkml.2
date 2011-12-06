Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1LFWgl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:36:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab1LFWgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:36:40 -0500
Date: Tue, 6 Dec 2011 14:36:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] rapidio/tsi721: Fix mailbox resource reporting
Message-Id: <20111206143638.12598c7b.akpm@linux-foundation.org>
In-Reply-To: <1323198088-11669-1-git-send-email-alexandre.bounine@idt.com>
References: <1323198088-11669-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Dec 2011 14:01:27 -0500
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Report support of four RapidIO mailboxes (MBOX0 - MBOX3) instead of MBOX0
> only.

I don't know how important these changes are and I don't know what
their end user visible effects are.  Hence I am unable to decide which
kernel version(s) we should merge the patches into.

That's why these things should always be explained in changelogs,
please.

