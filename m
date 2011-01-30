Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab1A3ApI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:45:08 -0500
Received: from lo.gmane.org ([80.91.229.12]:35789 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1A3ApH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:45:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Subject: Re: [PATCH 7/7] perf tools: Initial python binding
Date: Sun, 30 Jan 2011 00:39:15 +0000 (UTC)
Message-ID: <loom.20110130T013317-927@post.gmane.org>
References: <1296339559-20914-1-git-send-email-acme@infradead.org> <1296339559-20914-8-git-send-email-acme@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 141.85.37.41 (Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/534.17 (KHTML, like Gecko) Ubuntu/10.10 Chromium/10.0.651.0 Chrome/10.0.651.0 Safari/534.17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo <acme <at> infradead.org> writes:
> --- /dev/null
> +++ b/tools/perf/python/twatch.py
> @@ -0,0 +1,41 @@
> +#! /usr/bin/python


> +++ b/tools/perf/util/setup.py
> @@ -0,0 +1,18 @@
> +#!/usr/bin/python2


Shouldn't both of these be?
#!/usr/bin/env python

--
Lucian

