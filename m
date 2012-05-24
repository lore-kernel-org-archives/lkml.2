Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017Ab2EXBXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:23:34 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:50544 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754750Ab2EXBXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:23:32 -0400
Message-ID: <1337822611.4279.3.camel@joe2Laptop>
Subject: Re: [PATCH v2 12/14] Closures
From: Joe Perches <joe@perches.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Date: Wed, 23 May 2012 18:23:31 -0700
In-Reply-To: <20120524011654.GA28662@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
	 <1337817771-25038-13-git-send-email-koverstreet@google.com>
	 <1337820443.1747.24.camel@joe2Laptop>
	 <20120524011654.GA28662@dhcp-172-18-216-138.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 21:16 -0400, Kent Overstreet wrote:
> > or maybe just bundle all this in a single seq_printf
> Do you mean something like this?
> seq_printf(f, "%s%s%s%s%s\n",
> 	   r & CLOSURE_RUNNING	? "R" : "",
> 	   r & CLOSURE_BLOCKING ? "B" : "");

Yes.

> Or do you have a better way of writing that in mind?

No.

cheers, Joe

