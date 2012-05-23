Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab2EWIK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 04:10:28 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58044 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2EWIKW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 04:10:22 -0400
Message-ID: <1337760613.9698.52.camel@twins>
Subject: Re: [PATCH v2 4/5] perf record: add meta-data support for pipe-mode
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org
Date: Wed, 23 May 2012 10:10:13 +0200
In-Reply-To: <20120523010157.GB19962@infradead.org>
References: <1337081295-10303-1-git-send-email-eranian@google.com>
	 <1337081295-10303-5-git-send-email-eranian@google.com>
	 <4FB32032.3000509@gmail.com>
	 <CABPqkBQyZfSczhAROdH8p0_asy=c2AJho4Kv9wRYabaLNKkURA@mail.gmail.com>
	 <4FB67DE5.8050000@gmail.com> <20120518171911.GH2636@infradead.org>
	 <1337708035.9698.44.camel@twins>
	 <CABPqkBTQ=K-=qkgzC0TZPi1xyHtqT6QQroRg-7o0k8rFmjH_Bw@mail.gmail.com>
	 <87obpf209z.fsf@sejong.aot.lge.com> <20120523010157.GB19962@infradead.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 22:01 -0300, Arnaldo Carvalho de Melo wrote:
> 
> 
> But at the same time I don't think reusing the existing mechanism is
> such a big problem as Peter makes of it :-\ 

Probably not, but just know that I'll not take any such abuse into
consideration when adding new record types.

That pipe mess is ill-designed and I don't care about it.
