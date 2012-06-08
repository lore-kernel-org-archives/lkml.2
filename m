Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758106Ab2FHSb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 14:31:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753003Ab2FHSb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 14:31:28 -0400
Date: Fri, 8 Jun 2012 14:04:18 -0400
From: Dave Jones <davej@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
        Tom Herbert <therbert@google.com>
Subject: Re: vmsplice triggering bug in kfree.
Message-ID: <20120608180418.GA2338@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, axboe@kernel.dk,
	Tom Herbert <therbert@google.com>
References: <20120607025117.GA28261@redhat.com>
 <1339043263.26966.79.camel@edumazet-glaptop>
 <1339044013.26966.80.camel@edumazet-glaptop>
 <1339048365.26966.89.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339048365.26966.89.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 07:52:45AM +0200, Eric Dumazet wrote:
 > On Thu, 2012-06-07 at 06:40 +0200, Eric Dumazet wrote:
 > > On Thu, 2012-06-07 at 06:27 +0200, Eric Dumazet wrote:
 > > 
 > > > Thanks Dave, I'll take a look today on this report.
 > > > 
 > > 
 > > OK, trivial bug, I am testing a fix, thanks again.
 > > 
 > 
 > Not sure if you can reproduce this bug easily, if so could you test
 > following patch ?

haven't seen this reoccur since applying this patch, so it looks good to me.

Tested-by: Dave Jones <davej@redhat.com>
