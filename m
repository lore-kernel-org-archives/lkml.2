Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab2HUMPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:15:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47519 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2HUMPA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:15:00 -0400
Message-ID: <1345551283.23018.106.camel@twins>
Subject: Re: [PATCH] fbcon: fix race condition between console lock and
 cursor timer
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Airlie <airlied@redhat.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Josh Boyer <jwboyer@gmail.com>
Date: Tue, 21 Aug 2012 14:14:43 +0200
In-Reply-To: <1345531207-24926-1-git-send-email-airlied@redhat.com>
References: <1345531207-24926-1-git-send-email-airlied@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-08-21 at 16:40 +1000, Dave Airlie wrote:
> So after much tracing with direct netconsole writes (printks
> under console_lock not so useful) 

I always use earlyprintk on serial.. 
