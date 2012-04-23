Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab2DWSi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:38:58 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61309 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2DWSi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:38:56 -0400
Date: Mon, 23 Apr 2012 15:39:01 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Ulrich Drepper <drepper@akkadia.org>
Cc: a.p.zijlstra@chello.nl, dsahern@gmail.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com, paulus@samba.org,
        robert.richter@amd.com
Subject: Re: [PATCH] Small perf cleanup
Message-ID: <20120423183901.GA15385@infradead.org>
References: <201204231304.q3ND4TFe020805@drepperk.user.openhosting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204231304.q3ND4TFe020805@drepperk.user.openhosting.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Apr 23, 2012 at 09:04:29AM -0400, Ulrich Drepper escreveu:
> I just noticed this.  The if branch is completely unnecessary since
> 'realloc' handles NULL pointers for the first parameter.  This is
> really only a cleanup and submitted mainly to prevent proliferation
> of bad practices.

Thanks, applied to my perf/core branch at:

http://git.kernel.org/?p=linux/kernel/git/acme/linux.git;a=shortlog;h=refs/heads/perf/core

- Arnaldo
