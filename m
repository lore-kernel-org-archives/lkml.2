Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0D0SNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 14:13:35 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:49477 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab0D0SNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 14:13:34 -0400
Date: Tue, 27 Apr 2010 20:13:32 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Linux-Next <linux-next@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>
Subject: Re: linux-next: April 27 (mm/page-writeback)
Message-ID: <20100427181332.GM27497@kernel.dk>
References: <8ea19b02-d4d8-4000-9842-fec7f5bcf90d@default> <20100427110807.d8641ace.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427110807.d8641ace.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27 2010, Andrew Morton wrote:
> On Tue, 27 Apr 2010 09:19:30 -0700 (PDT)
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > When CONFIG_BLOCK is not enabled:
> > 
> > mm/page-writeback.c:707: error: dereferencing pointer to incomplete type
> > mm/page-writeback.c:708: error: dereferencing pointer to incomplete type
> > 
> 
> Subject: "laptop-mode: Make flushes per-device" fix
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> When CONFIG_BLOCK is not enabled:
> 
> mm/page-writeback.c:707: error: dereferencing pointer to incomplete type
> mm/page-writeback.c:708: error: dereferencing pointer to incomplete type

Thanks Andrew, I've added this to the .35 branch.

-- 
Jens Axboe

