Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757051Ab2CUJLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:11:17 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47579 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2CUJLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:11:13 -0400
MIME-Version: 1.0
In-Reply-To: <1332320378-30652-1-git-send-email-ming.lei@canonical.com>
References: <1332320378-30652-1-git-send-email-ming.lei@canonical.com>
Date: Wed, 21 Mar 2012 17:11:10 +0800
Message-ID: <CACVXFVNa=Gp3Y61tju8Oq6XtqRpQA=n0ruA6uBuv0M8_QiTk7w@mail.gmail.com>
Subject: Re: [PATCH] perf tool: fix compile failure with missed 'linux/export.h'
From: Ming Lei <ming.lei@canonical.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 4:59 PM, Ming Lei <ming.lei@canonical.com> wrote:
> Just fake a export.h under util/include/linux so that perf
> can be built successfully.

lib/rbtree.c changed to include <linux/export.h>, so compile failure
is triggered to
build perf on -next.

Sorry for missing the above description in commit log.

Thanks,
--
Ming Lei
