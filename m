Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab2J3ISS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:18:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:59516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2J3ISN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:18:13 -0400
Message-ID: <1351585065.4047.33.camel@twins>
Subject: Re: [RFC/PATCHSET 00/15] perf report: Add support to accumulate
 hist periods
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arun Sharma <asharma@fb.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Date: Tue, 30 Oct 2012 09:17:45 +0100
In-Reply-To: <87ehkg78dx.fsf@sejong.aot.lge.com>
References: <1347520811-28150-1-git-send-email-namhyung@kernel.org>
	 <1351537727.4047.21.camel@twins> <508EF6C1.4000302@fb.com>
	 <87ehkg78dx.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 15:59 +0900, Namhyung Kim wrote:
> Yes, the callchain part needs to be improved.  Peter's idea indeed looks
> good to me too. 

FWIW, I think this is exactly what sysprof does, except that tool isn't
usable for other reasons.. You might want to look at it though.
