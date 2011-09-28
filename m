Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1I1P2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:28:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:49200 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab1I1P17 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:27:59 -0400
Subject: Re: [RFD 0/9] per-cgroup /proc/stat statistics
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, paul@paulmenage.org, lizf@cn.fujitsu.com,
        daniel.lezcano@free.fr, jbottomley@parallels.com
Date: Wed, 28 Sep 2011 17:27:24 +0200
In-Reply-To: <4E833B8A.6020708@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	 <1317161513.21836.28.camel@twins> <4E833B8A.6020708@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317223645.24040.50.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 12:21 -0300, Glauber Costa wrote:
> >  From a conceptual pov this patch-set is a lot saner than the previous
> > one, doesn't duplicate nearly as much and actually tries to improve the
> > code (although I suspect simply killing off cputime64_t as a whole will
> > get us even more).
> 
> Are you actually planning to do that by yourself ?

I could, but I think I need to sort that out with Martin first.
