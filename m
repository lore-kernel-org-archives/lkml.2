Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab2IYLRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 07:17:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab2IYLRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 07:17:34 -0400
Date: Tue, 25 Sep 2012 08:17:03 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>, mingo@elte.hu, a.p.zijlstra@chello.nl,
        andi@firstfloor.org, dsahern@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 8/9] perf hists browser: Add option for runtime
 switching perf data file
Message-ID: <20120925111703.GC28902@infradead.org>
References: <1348500251-9937-1-git-send-email-feng.tang@intel.com>
 <1348500251-9937-9-git-send-email-feng.tang@intel.com>
 <87d31ayhpy.fsf@sejong.aot.lge.com>
 <20120925162053.51f60773@feng-i7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925162053.51f60773@feng-i7>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Sep 25, 2012 at 04:20:53PM +0800, Feng Tang escreveu:
> On Tue, 25 Sep 2012 11:11:21 +0900
> Namhyung Kim <namhyung@kernel.org> wrote:
> > Ditto.  Plus it might leak previous input_name.
> 
> Nice catch, will check the return value of "strdup". 
> 
> For input_name mem leak, in some cases the input_name can't be called
>  with free(), like those got from parse "-i" option. In case the old
> input_name is got from malloc through strdup, I think it's not a big
> issue given that buffer will be freed any way when the application exit.

I think this is a matter of discipline, leaking is bad, kernel or
userspace, why special case it?

- Arnaldo
