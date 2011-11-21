Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967Ab1KUP4J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 10:56:09 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45582 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KUP4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 10:56:06 -0500
Date: Mon, 21 Nov 2011 13:56:02 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH] perf script: Add comm filtering option
Message-ID: <20111121155602.GC2325@ghostprotocols.net>
References: <1321641585-5643-1-git-send-email-dsahern@gmail.com>
 <20111121125831.GA2325@ghostprotocols.net>
 <4ECA723B.9090200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ECA723B.9090200@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Nov 21, 2011 at 08:46:03AM -0700, David Ahern escreveu:
> On 11/21/2011 05:58 AM, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Nov 18, 2011 at 11:39:45AM -0700, David Ahern escreveu:
> >> Allows collecting events system wide and then pulling out events
> >> for a specific task name(s). e.g,
> >>
> >>     perf script -c gnome-shell,gnome-terminal
> >>
> >> Applies on top of:
> >>     https://lkml.org/lkml/2011/11/13/74
> > 
> > Can't we just reuse symbol_conf.comm_list[_str]?
> >  
> > - Arnaldo
> 
> For now, yes. I'll redo.

Great, if we have any need to have those in separate variables in the
future, no problem we can do that at that point.

- Arnaldo
