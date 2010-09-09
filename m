Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab0IIQop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:44:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492Ab0IIQon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:44:43 -0400
Date: Thu, 9 Sep 2010 13:44:20 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: Fix crash when vmlinux_path__exit().
Message-ID: <20100909164420.GD4155@ghostprotocols.net>
References: <1284043690.2000.8.camel@cowboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284043690.2000.8.camel@cowboy>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Sep 09, 2010 at 10:48:10AM -0400, Davidlohr Bueso escreveu:
> [PATCH] perf: Fix crash when vmlinux_path__exit()
> 
> When running perf {timechart,sched} record an incorrect freeing occurs after Ctrl-C'ing to
> exit the application, the following is seen:

There was a fix for this that just checked if it was already
initialized, lemme check.

You don't mention what is the git tree you are using or if this is from
some tarball, can you clarify?

- Arnaldo
