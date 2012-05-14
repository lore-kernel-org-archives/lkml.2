Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756734Ab2ENNsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:48:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40900 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2ENNsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:48:18 -0400
Date: Mon, 14 May 2012 10:48:13 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
Message-ID: <20120514134813.GA4254@infradead.org>
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, May 13, 2012 at 10:01:28PM -0600, David Ahern escreveu:
> 764e16a changed perf-record to create events disabled by default and
> enable them once perf initializations are done. This setting was dropped
> by 0f82ebc. Now perf events are once again generated during perf's
> initialization phase (e.g., generating maps).

Gack, I really need to finally read about that autotest stuff and we
should start writing more and more regression tests to avoid this kind
of stuff.

- Arnaldo
