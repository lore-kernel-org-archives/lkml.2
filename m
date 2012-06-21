Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760481Ab2FUWqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 18:46:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760083Ab2FUWqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 18:46:30 -0400
Date: Thu, 21 Jun 2012 15:46:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, torvalds@linux-foundation.org,
        zheng.z.yan@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86: Add generic Intel uncore PMU support
Message-Id: <20120621154629.b157f376.akpm@linux-foundation.org>
In-Reply-To: <20120621154334.05a74517.akpm@linux-foundation.org>
References: <1339741902-8449-6-git-send-email-zheng.z.yan@intel.com>
	<tip-087bfbb032691262f2f7d52b910652450c5554b8@git.kernel.org>
	<20120621154334.05a74517.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012 15:43:34 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> i386 allmodconfig:

err, make that allnoconfig.
