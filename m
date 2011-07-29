Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1G2KGO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 06:06:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413Ab1G2KGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 06:06:13 -0400
Date: Fri, 29 Jul 2011 11:06:09 +0100
From: Mel Gorman <mgorman@suse.de>
To: Keiichi KII <k-keiichi@bx.jp.nec.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        "BA, Moussa" <Moussa.BA@numonyx.com>
Subject: Re: [RFC PATCH -tip 4/5] tracepoints: add tracepoints for pagecache
Message-ID: <20110729100609.GR3010@suse.de>
References: <4E24A61D.4060702@bx.jp.nec.com>
 <4E24A7BB.1040800@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E24A7BB.1040800@bx.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 05:38:03PM -0400, Keiichi KII wrote:
> From: Keiichi Kii <k-keiichi@bx.jp.nec.com>
> 
> This patch adds several tracepoints to track pagecach behavior.
> These trecepoints would help us monitor pagecache usage with high resolution.
> 

There are a few spelling mistakes there but what harm. This is an RFC.

Again, it would be really nice if the changelog explained why it was
useful to monitor pagecache usage at this resolution. For example,
I could identify files with high and low hit ratios and conceivably
identify system activity that resulted in page cache being trashed.
However, even in that case, I don't necessarily care which files got
chucked out and that sort of problem can also be seen via fault rates.

Another scenario that may be useful is it could potentially identify an
application bug that was invalidating a portion of a file that was in
fact hot and in use by other processes. I'm sure you have much better
examples that motivated the development of this series :)

The tracepoints themselves look fine.

-- 
Mel Gorman
SUSE Labs
