Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2HUMQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:16:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48245 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab2HUMQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:16:06 -0400
Message-ID: <1345551345.23018.107.camel@twins>
Subject: Re: [PATCH] fbcon: fix race condition between console lock and
 cursor timer
From: Peter Zijlstra <peterz@infradead.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@gmail.com>
Date: Tue, 21 Aug 2012 14:15:45 +0200
In-Reply-To: <20120821101505.61c0221a@pyramind.ukuu.org.uk>
References: <1345531207-24926-1-git-send-email-airlied@redhat.com>
	 <20120821101505.61c0221a@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 10:15 +0100, Alan Cox wrote:
> > So after much tracing with direct netconsole writes (printks
> > under console_lock not so useful), I think I found the race.
> 
> Direct netconsole write would be a useful patch to have mainline I think
> 8) 

could we make that use the earlyprintk infrastructure?
