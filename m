Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab2BORbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:31:32 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49298 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab2BORbb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:31:31 -0500
Message-ID: <1329327045.2293.156.camel@twins>
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: David Ahern <dsahern@gmail.com>
Cc: Luigi Semenzato <semenzato@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Date: Wed, 15 Feb 2012 18:30:45 +0100
In-Reply-To: <4F3BE3F9.2010002@gmail.com>
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org>
	 <1329310113.2293.72.camel@twins> <4F3BE3F9.2010002@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 09:57 -0700, David Ahern wrote:
> 
> I'm not Acme, but I do care. We use a lot of processes with named 
> threads that give users an idea about the function of a particular
> thread.
> 
But why would they care? If you're debugging its easy enough to see from
the backtrace and if you're not, most tools like top/ps don't even show
threads (by default).

So who cares what threads are called.

I realize I'm not going to convince anybody, but I genuinely don't see
the point of naming threads.
