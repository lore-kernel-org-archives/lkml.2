Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413Ab2F0T6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:58:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:57630 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756014Ab2F0T6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:58:33 -0400
Message-ID: <1340827102.10063.72.camel@twins>
Subject: Re: [PATCH] perf: fix wrong hw_breakpoint documentation
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Namhyung Kim <namhyung@kernel.org>, Jovi Zhang <bookjovi@gmail.com>,
        mingo@redhat.com, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 27 Jun 2012 21:58:22 +0200
In-Reply-To: <20120627190725.GA1380@krava.redhat.com>
References: <CACV3sbKFcHgai6AzKGrf=LEb67VjZXjMUqMQuXAOUmby7CeiJg@mail.gmail.com>
	 <87fw9hyvt5.fsf@sejong.aot.lge.com> <20120627161557.GA3878@infradead.org>
	 <20120627190725.GA1380@krava.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-27 at 21:07 +0200, Jiri Olsa wrote:
> -modifier_bp    [rwx]
> +modifier_bp    [rwx]{1,3}
> 
> and fail parse_breakpoint_type function for nonsense types

If you're going to modify parse_breakpoint_type() to fail on nonsense
types, you might as well do the + thing, right?

Doesn't really matter that much though ;-)
