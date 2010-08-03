Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab0HCWwN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 18:52:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932797Ab0HCWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 18:52:11 -0400
Date: Tue, 3 Aug 2010 15:51:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        arjan@linux.intel.com, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep_range timer
Message-Id: <20100803155134.b3c4bf73.akpm@linux-foundation.org>
In-Reply-To: <1280786467-26999-2-git-send-email-ppannuto@codeaurora.org>
References: <1280786467-26999-1-git-send-email-ppannuto@codeaurora.org>
	<1280786467-26999-2-git-send-email-ppannuto@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  2 Aug 2010 15:01:04 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> usleep_range is a finer precision implementations of msleep
> and is designed to be a drop-in replacement for udelay where
> a precise sleep / busy-wait is unnecessary.

Thomas has merged an older version of this patch into his tree.  He
doesn't appear to have merged the other three patches.  I queued a
revert of the old patch to remove it from linux-next and I then queued
the other three.

Now I'll just sit here and see what happens.
