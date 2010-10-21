Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab0JUWcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 18:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751559Ab0JUWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 18:32:06 -0400
Date: Thu, 21 Oct 2010 15:31:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Dave Chinner <david@fromorbit.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/17] fs: Convert nr_inodes to a per-cpu counter
Message-Id: <20101021153126.c1693e8e.akpm@linux-foundation.org>
In-Reply-To: <1287221475.2799.123.camel@edumazet-laptop>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	<1285762729-17928-17-git-send-email-david@fromorbit.com>
	<20100929215322.ff635d3e.akpm@linux-foundation.org>
	<20100930061039.GX5665@dastard>
	<20101016075510.GH19147@amd>
	<1287217748.2799.68.camel@edumazet-laptop>
	<20101016020744.366bd9c6.akpm@linux-foundation.org>
	<1287221475.2799.123.camel@edumazet-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(working in time-reversed oreder again :()

On Sat, 16 Oct 2010 11:31:15 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Btw, I believe my previous patch against include/linux/percpu_counter.h
> was lost. Are you sure I am the right guy to work on percpu_counter
> infra ? If yes I can implement your inlined idea.

I don't know what "previous patch" you're referring to.
