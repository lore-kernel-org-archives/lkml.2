Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab2IEWIJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 18:08:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:33638 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759677Ab2IEWII convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 18:08:08 -0400
Message-ID: <1346882872.2600.63.camel@twins>
Subject: Re: [PATCH 08/11] perf tool: precise mode requires exclude_guest
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>, Avi Kivity <avi@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Thu, 06 Sep 2012 00:07:52 +0200
In-Reply-To: <50477332.1000902@gmail.com>
References: <1342826756-64663-1-git-send-email-dsahern@gmail.com>
	 <1342826756-64663-9-git-send-email-dsahern@gmail.com>
	 <20120723181358.GC6717@infradead.org> <500EAF23.8060909@gmail.com>
	 <20120724161507.GG3732@erda.amd.com> <500EDB50.3070704@gmail.com>
	 <20120724180312.GJ6717@infradead.org> <5010D2B1.3000206@gmail.com>
	 <1343290109.26034.82.camel@twins> <20120803135117.GC3732@erda.amd.com>
	 <50477332.1000902@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-05 at 09:43 -0600, David Ahern wrote:
> 
> We need to require exclude_guest when using precise attribute with perf 
> else all running VMs on Intel-based servers will crash. I do not have an 
> AMD based server to even attempt the preferred solution.

I've recently gotten a machine from AMD that would allow me to test this
stuff, so I'll put writing that somewhere near the top of the todo.

>  Best I can do 
> is to attempt to keep this thread alive until someone with one can 
> tackle the problem. 

Right you are.. keep doing this until its sorted.
