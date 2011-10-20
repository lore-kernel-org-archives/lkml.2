Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab1JTV3Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 17:29:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab1JTV3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 17:29:15 -0400
Date: Thu, 20 Oct 2011 19:28:50 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        nhorman@tuxdriver.com, eric.dumazet@gmail.com
Subject: Re: [PATCHv4] perf tools: Fix tracing info recording
Message-ID: <20111020212850.GA10947@ghostprotocols.net>
References: <1317028312-5156-1-git-send-email-jolsa@redhat.com> <1317308709-9474-1-git-send-email-jolsa@redhat.com> <1317308709-9474-3-git-send-email-jolsa@redhat.com> <20111013140040.GD4125@jolsa.brq.redhat.com> <20111020135943.GD2092@jolsa.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020135943.GD2092@jolsa.brq.redhat.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Oct 20, 2011 at 03:59:43PM +0200, Jiri Olsa escreveu:
> hi,
> sending version updated to the latest tip tree code.

Thanks for refreshing it, applied. I'll push it together with some other
changes after Ingo pulls what I have in perf/core.

- Arnaldo
