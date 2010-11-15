Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab0KOVe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:34:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60196 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab0KOVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:34:56 -0500
Date: Mon, 15 Nov 2010 16:34:44 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: jaxboe@fusionio.com
Cc: device-mapper development <dm-devel@redhat.com>,
        "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>,
        Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] block: rename trace_block_remap to
 trace_block_bio_remap
Message-ID: <20101115213444.GA25705@redhat.com>
References: <4AB3A393.5000709@ce.jp.nec.com>
 <4AB4F908.60307@ce.jp.nec.com>
 <20101103215047.GC26473@redhat.com>
 <20101115205815.GA25567@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115205815.GA25567@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15 2010 at  3:58pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Hi Jens,
> 
> This may have slipped through while you were traveling?
> 
> Patch is also available here:
> https://patchwork.kernel.org/patch/300552/
> 
> Not sure if this change is concerning on a kABI level?

To be clear: that concern/question was prompted from having taken a
quick glance at lwn's kernel summit "KS2010: ABI status for tracepoints"
coverage: http://lwn.net/Articles/412685/

But in that article it clearly states:
"there are to be no stable tracepoints in drivers or filesystems".

Not sure where that leaves tracepoints for the block layer.  Anyway,
seems tracepoint kABI is likely a concern for the future (not the
immediate future).

So this change would be nice to get in before there is a new tracepoint
kABI-aware sheriff in town.

Mike
