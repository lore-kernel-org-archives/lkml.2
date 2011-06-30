Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab1F3TTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 15:19:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55009 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753724Ab1F3TTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 15:19:12 -0400
Date: Thu, 30 Jun 2011 12:19:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] x86: Implement strict user copy checks for x86_64
Message-Id: <20110630121909.d4ac1bfc.akpm@linux-foundation.org>
In-Reply-To: <1306865673-20560-4-git-send-email-sboyd@codeaurora.org>
References: <1306865673-20560-1-git-send-email-sboyd@codeaurora.org>
	<1306865673-20560-4-git-send-email-sboyd@codeaurora.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011 11:14:32 -0700
Stephen Boyd <sboyd@codeaurora.org> wrote:

> Strict user copy checks are only really supported on x86_32 even
> though the config option is selectable on x86_64. Add the
> necessary support to the 64 bit code to trigger copy_from_user()
> warnings at compile time.

So I'm getting 20-30 warnings from an x86_64 allmodconfig build.

I don't think we want a million other people to have to put up with
those warnings too.  Can you please take a look at fixing these up?

