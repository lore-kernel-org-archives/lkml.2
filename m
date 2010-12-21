Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab0LUSki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:40:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:59712 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0LUSkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:40:33 -0500
Subject: Re: [PATCH -tip v2 2/6] perf bts: Introduce new sub command 'perf
 bts trace'
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20101221183131.GO1750@nowhere>
References: <20101221090527.8552.41486.stgit@localhost6.localdomain6>
	 <20101221090549.8552.26257.stgit@localhost6.localdomain6>
	 <20101221183131.GO1750@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Dec 2010 19:40:32 +0100
Message-ID: <1292956832.2170.17.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-21 at 19:31 +0100, Frederic Weisbecker wrote:
> Actually the best would be to select PERF_SAMPLE_ID in the sample_type
> on record and also PERF_FORMAT_ID in the read_format.

That would grow the data size for little gain, as long as you only
record BTS data into the buffer the current bits should work fine.
