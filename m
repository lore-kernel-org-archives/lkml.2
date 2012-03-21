Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964903Ab2CUJPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:15:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:46476 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2CUJPf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:15:35 -0400
Message-ID: <1332321311.18960.474.camel@twins>
Subject: Re: [PATCH 3/3] perf, tool: Add new event group management
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>, acme@redhat.com, mingo@elte.hu,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Date: Wed, 21 Mar 2012 10:15:11 +0100
In-Reply-To: <20120320204625.GA17142@gmail.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
	 <1332267341-26338-4-git-send-email-jolsa@redhat.com>
	 <1332269081.18960.444.camel@twins> <20120320204625.GA17142@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 21:46 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > Now the disadvantage is that {} needs quotes on bash, [...]
> 
> Not on my version of Bash:
> 
>  earth5:~> perf stat {}
>  {}: No such file or directory
>  Terminated
>  earth5:~> perf stat true {}
> 
>   Performance counter stats for 'true {}':
> 
> it's passed in literally, AFAICS.

# echo {}
{}
# echo {en,dis}able
enable disable


It somehow special cases {}, which is horrible.
