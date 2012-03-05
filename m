Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030177Ab2CEUhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:37:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab2CEUhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:37:16 -0500
Date: Mon, 5 Mar 2012 12:37:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexandre Bounine <alexandre.bounine@idt.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Chul Kim <chul.kim@idt.com>, Matt Porter <mporter@kernel.crashing.org>
Subject: Re: [PATCH] rapidio/tsi721: fix bug in inbound doorbell handler
Message-Id: <20120305123714.0750129e.akpm@linux-foundation.org>
In-Reply-To: <1330979585-29429-1-git-send-email-alexandre.bounine@idt.com>
References: <1330979585-29429-1-git-send-email-alexandre.bounine@idt.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  5 Mar 2012 15:33:05 -0500
Alexandre Bounine <alexandre.bounine@idt.com> wrote:

> Fixes queue wrapping bug in Inbound Doorbell handling routine.

The changelog doesn't describe the user-visible impact of the bug. 
Please always include this so that people know whether to backport the
fix into their kernels, and so they can determine whether the patch
will fix a problem which they are observing.

