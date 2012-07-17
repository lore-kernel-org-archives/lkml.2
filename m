Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab2GQTky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:40:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab2GQTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:40:50 -0400
Date: Tue, 17 Jul 2012 12:40:45 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, tglx@linutronix.de, linux-pm@vger.kernel.org
Subject: Re: [PATCHSET] workqueue: reimplement CPU hotplug to keep idle
 workers
Message-ID: <20120717194045.GB24336@google.com>
References: <1342545149-3515-1-git-send-email-tj@kernel.org>
 <201207172043.42659.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201207172043.42659.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 17, 2012 at 08:43:42PM +0200, Rafael J. Wysocki wrote:
> I suppose you're going to push them through your tree, right?  I that case
> please free to add my Acked-by to them.

Yeah, I'm planning to push these through workqueue tree once 3.6 merge
window opens.  Acked-bys added.

Thanks!

-- 
tejun
