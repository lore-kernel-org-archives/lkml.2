Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab2AHPtW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 10:49:22 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49037 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753754Ab2AHPtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 10:49:21 -0500
Subject: Re: [PATCH] perf tools: Fix compile error on x86_64 Ubuntu
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20120108153237.GA11891@elte.hu>
References: <20120108150012.GA7570@elte.hu>
	 <1326035430-7621-1-git-send-email-namhyung@gmail.com>
	 <20120108151207.GA26660@infradead.org>  <20120108153237.GA11891@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Jan 2012 00:49:14 +0900
Message-ID: <1326037754.1947.9.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-01-08 (일), 16:32 +0100, Ingo Molnar: 
> * Arnaldo Carvalho de Melo <acme@ghostprotocols.net> wrote:
> 
> > Em Mon, Jan 09, 2012 at 12:10:30AM +0900, Namhyung Kim escreveu:
> > > ctype.h is not needed here and it breaks build on some system
> > > (at least 64bit Ubuntu 10.04) like below. Just get rid of it.
> > 
> > Thanks, applying it together with your previous patchset.
> 
> Note that there are other ctype.h inclusions elsewhere as well, 
> which should be considered for removal as well.
> 
> Thanks,
> 
> 	Ingo

Hi,

I'll look into them as well later.

Thanks.


-- 
Regards,
Namhyung Kim



