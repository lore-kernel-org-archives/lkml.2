Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2BDNZD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 08:25:03 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58897 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab2BDNZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 08:25:01 -0500
Date: Sat, 4 Feb 2012 14:24:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: rostedt@goodmis.org, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Subject: Re: [PATCHv8 0/2] first 2 patches passed review
Message-ID: <20120204132455.GD13382@somewhere>
References: <1328278128.5882.145.camel@gandalf.stny.rr.com>
 <1328278959-5775-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328278959-5775-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 03:22:37PM +0100, Jiri Olsa wrote:
> ok, sending 1st 2 patches separatelly
> 
> thanks,
> jirka

Please also keep the acks, unless you do some noticeable change :)

> ---
>  include/linux/ftrace.h |   70 ++++++++++++++++++++++++++-
>  kernel/trace/ftrace.c  |  126 +++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/trace/trace.h   |    2 +
>  3 files changed, 183 insertions(+), 15 deletions(-)
