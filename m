Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1KRAlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 19:41:45 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41341 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755335Ab1KRAlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 19:41:44 -0500
Date: Thu, 17 Nov 2011 22:41:39 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, peterz@infradead.org,
        fweisbec@gmail.com
Subject: Re: [PATCH v2] perf tools: make -C consistent across commands (for
 cpu list arg)
Message-ID: <20111118004139.GA2315@ghostprotocols.net>
References: <1321209008-7004-1-git-send-email-dsahern@gmail.com>
 <4EC59460.7020705@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EC59460.7020705@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 17, 2011 at 04:10:24PM -0700, David Ahern escreveu:
> On 11/13/2011 11:30 AM, David Ahern wrote:
> > Currently the meaning of -C varies by perf command: for perf-top,
> > perf-stat, perf-record it means cpu list. For perf-report it
> > means comm list. Then perf-annotate, perf-report and perf-script
> > use -c for cpu list.
> > 
> > Fix annotate, report and script to use -C for cpu list to be
> > consistent with top, stat and record. This means report needs
> > to use -c for comm list which does introduce a backward
> > compatibility change.
> 
> Any objections to making this argument consistent? I am waiting to send
> a follow-on patch that adds comm filtering to perf-script.

Its OK for perf/core, I'll apply and try to publish what I have
tomorrow.
 
- Arnaldo
