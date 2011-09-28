Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1I1PiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 11:38:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:49383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1I1PiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 11:38:15 -0400
Subject: Re: [RFD 4/9] Make total_forks per-cgroup
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Glauber Costa <glommer@parallels.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com, daniel.lezcano@free.fr,
        jbottomley@parallels.com, Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Wed, 28 Sep 2011 17:37:38 +0200
In-Reply-To: <4E833ED4.4020205@parallels.com>
References: <1316816432-9237-1-git-send-email-glommer@parallels.com>
	   <1316816432-9237-5-git-send-email-glommer@parallels.com>
	   <1317160837.21836.21.camel@twins> <20110928101357.5a90c2ab@de.ibm.com>
	   <1317206124.20318.6.camel@twins> <20110928144218.6a4882e5@de.ibm.com>
	  <1317214418.24040.13.camel@twins> <4E833D6D.1030407@parallels.com>
	 <1317224038.24040.52.camel@twins> <4E833ED4.4020205@parallels.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317224258.24040.53.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-28 at 12:35 -0300, Glauber Costa wrote:
> 
> So let me get this straight: The proposal here is really to get rid of 
> all cputime_t , not only cputime64_t ? 

For now cputime64_t would be sufficient, just wanted to extend the
argument with Martin to see if we really need the cputime*() trickery at
all.


