Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1I1PVG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:21:06 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43973 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab1I1PVD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:21:03 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v7)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, ak@linux.intel.com,
        mingo@elte.hu
Date: Wed, 28 Sep 2011 17:20:19 +0200
In-Reply-To: <CABPqkBRJydnzYK=OXpX+fTXUwraSf4PzEfiDmMjZLyZRYgRiVw@mail.gmail.com>
References: <20110928074842.GA5624@quad> <4E832360.4080205@gmail.com>
	 <CABPqkBRJydnzYK=OXpX+fTXUwraSf4PzEfiDmMjZLyZRYgRiVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317223219.24040.47.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 16:06 +0200, Stephane Eranian wrote:
>         > +     size_t len = 0;
>         > +     u32 i = 0;
>         > +     int ret = -1;
>         > +
>         > +     ret = -1;
>         
>         
>         Missed this yesterday. gcc-4.6 (e.g., Fedora 15) throws an error on this:
>         
>         util/header.c: In function ‘build_cpu_topo’:
>         util/header.c:461:6: error: variable ‘ret’ set but not used
>         [-Werror=unused-but-set-variable]
>         cc1: all warnings being treated as errors
>         
> Sorry about that. That means v8 is on the way, hopefully the final attempt... Thanks. 

Could we all please trim emails and not send html stuff?
