Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162278Ab2CSUUX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 16:20:23 -0400
Received: from mail-wi0-f194.google.com ([209.85.212.194]:52483 "EHLO
	mail-wi0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030720Ab2CSUUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 16:20:21 -0400
Date: Mon, 19 Mar 2012 21:20:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Colin Walters <walters@verbum.org>,
        Namhyung Kim <namhyung@gmail.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/3] perf/core fixes and improvements
Message-ID: <20120319202017.GA31406@gmail.com>
References: <1332184368-1655-1-git-send-email-acme@infradead.org>
 <20120319194725.GA31940@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319194725.GA31940@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> I noticed that there's no help text for GTK support - how will a 
> user find that 'perf report --gtk' will do something nice?

Ignore this one - I forgot to do 'make install-doc'.

Thanks,

	Ingo
