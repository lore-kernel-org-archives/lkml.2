Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757398Ab2CTUqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:46:36 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:42163 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab2CTUqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:46:34 -0400
Date: Tue, 20 Mar 2012 21:46:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
Message-ID: <20120320204625.GA17142@gmail.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
 <1332269081.18960.444.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332269081.18960.444.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Now the disadvantage is that {} needs quotes on bash, [...]

Not on my version of Bash:

 earth5:~> perf stat {}
 {}: No such file or directory
 Terminated
 earth5:~> perf stat true {}

  Performance counter stats for 'true {}':

it's passed in literally, AFAICS.

Thanks,

	Ingo
