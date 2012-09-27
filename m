Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab2I0Br7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:47:59 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:55583 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab2I0Br6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:47:58 -0400
X-AuditID: 9c930179-b7bf9ae000000e4c-92-5063b040a665
Date: Thu, 27 Sep 2012 10:50:59 +0900
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
Message-ID: <20120927015059.GC10229@bbox>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
 <1348649419-16494-2-git-send-email-minchan@kernel.org>
 <CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
 <20120927013912.GB10229@bbox>
 <20120926184743.3dca1289.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120926184743.3dca1289.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 06:47:43PM -0700, Andrew Morton wrote:
> On Thu, 27 Sep 2012 10:39:12 +0900 Minchan Kim <minchan@kernel.org> wrote:
> 
> > So I and Nitin tried to ask the opinion to akpm several times
> > (at least 5 and even I sent such patch a few month ago) but didn't get
> > any reply from him so I guess he doesn't have any concern about that
> > any more.
> 
> I just haven't yet set aside a sufficiently large lump of time to work
> out what's going on here, sorry.  Will try to get onto it next week. 

Okay. Thanks Andrew.
I will wait your opinion.
Of course, promotion would be stuck by next week.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
