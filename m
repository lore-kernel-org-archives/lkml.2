Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab1ALPCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 10:02:12 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45467 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1ALPCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 10:02:11 -0500
Subject: Re: Q: perf log mode?
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20110112145936.GA13992@tugrik.mns.mnsspb.ru>
References: <20110112140613.GA11698@tugrik.mns.mnsspb.ru>
	 <1294841288.19601.49.camel@laptop> <20110112144240.GA1755@nowhere>
	 <20110112145936.GA13992@tugrik.mns.mnsspb.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 12 Jan 2011 16:02:33 +0100
Message-ID: <1294844553.19601.53.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-12 at 17:59 +0300, Kirill Smelkov wrote:
> 
> Anyway, maybe something like this could be useful?
> 
I guess that would be ok, but I'll leave that to Arnaldo.

Also note that Arnaldo is revamping the whole script interface to make
it possible to open and use the perf fds from the script language itself
(the only sane way), completely removing the dependency on perf-record.
