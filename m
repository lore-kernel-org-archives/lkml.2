Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1KUM6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:58:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59982 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab1KUM6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:58:38 -0500
Date: Mon, 21 Nov 2011 10:58:31 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf script: Add comm filtering option
Message-ID: <20111121125831.GA2325@ghostprotocols.net>
References: <1321641585-5643-1-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321641585-5643-1-git-send-email-dsahern@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Nov 18, 2011 at 11:39:45AM -0700, David Ahern escreveu:
> Allows collecting events system wide and then pulling out events
> for a specific task name(s). e.g,
> 
>     perf script -c gnome-shell,gnome-terminal
> 
> Applies on top of:
>     https://lkml.org/lkml/2011/11/13/74

Can't we just reuse symbol_conf.comm_list[_str]?
 
- Arnaldo
