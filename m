Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab0JZOeu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:34:50 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42601 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756841Ab0JZOet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:34:49 -0400
Date: Tue, 26 Oct 2010 15:34:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH] perf: Remove newline character from perror() argument
Message-ID: <20101026143448.GA21107@console-pimps.org>
References: <89e77b54659bc3798b23a5596c2debb7f6f4cf27.1283010281.git.matt@console-pimps.org> <20100828155251.GP2973@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100828155251.GP2973@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 28, 2010 at 12:52:51PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Sat, Aug 28, 2010 at 04:46:19PM +0100, Matt Fleming escreveu:
> > If we include a newline character in the string argument to perror()
> > then the output will be split across two lines like so,
> > 
> >     Unable to read perf file descriptor
> >     : No space left on device
> > 
> > Deleting the newline character prints a much more readable error,
> > 
> >     Unable to read perf file descriptor: No space left on device
> 
> Thanks, applying.
> 
> - Arnaldo

Hi Arnaldo,

Whatever happend to this? I can't see it in any of the perf trees.
