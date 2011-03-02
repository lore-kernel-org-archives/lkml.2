Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab1CBRCR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 12:02:17 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35786 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754749Ab1CBRCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 12:02:16 -0500
Subject: Re: [RFC PATCH 4/5] mm: Add hit/miss accounting for Page Cache
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Liu Yuan <namei.unix@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, jaxboe@fusionio.com, akpm@linux-foundation.org,
        fengguang.wu@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
In-Reply-To: <20110302084542.GA20795@elte.hu>
References: <no> <1299055090-23976-4-git-send-email-namei.unix@gmail.com>
	 <20110302084542.GA20795@elte.hu>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Wed, 02 Mar 2011 09:02:06 -0800
Message-ID: <1299085326.8493.820.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 09:45 +0100, Ingo Molnar wrote:
> But, instead of trying to improve those aspects of our existing instrumentation 
> frameworks, mm/* is gradually growing its own special instrumentation hacks, missing 
> the big picture and fragmenting the instrumentation space some more.
> 
> That trend is somewhat sad. 

Go any handy examples of how you'd like to see these done?

We're trying to add a batch of these for transparent huge pages, and
there was a similar set for KSM, so there's certainly no shortage of
potential sites.

-- Dave

