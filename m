Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2DWV7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 17:59:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:33865 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2DWV7J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 17:59:09 -0400
Message-ID: <1335218328.28150.181.camel@twins>
Subject: Re: [PATCH 05/16] sched: SCHED_DEADLINE policy implementation.
From: Peter Zijlstra <peterz@infradead.org>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, cfriesen@nortel.com, oleg@redhat.com,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, linux-kernel@vger.kernel.org,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com, paulmck@linux.vnet.ibm.com,
        raistlin@linux.it, insop.song@ericsson.com, liming.wang@windriver.com
Date: Mon, 23 Apr 2012 23:58:48 +0200
In-Reply-To: <4F95CFBF.1050000@sssup.it>
References: <1333696481-3433-1-git-send-email-juri.lelli@gmail.com>
	  <1333696481-3433-6-git-send-email-juri.lelli@gmail.com>
	 <1335182113.28150.132.camel@twins> <4F95CFBF.1050000@sssup.it>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 22:55 +0100, Tommaso Cucinotta wrote:
> why not write this straight in asm, i.e., multiply 64*64 then divide by 
> 64 keeping the intermediate result on 128 bits? 

If you know of a way to do this for all 30 odd architectures supported
by our beloved kernel, do let me know ;-)

Yes I can do it for x86_64, but people tend to get mighty upset if you
break the compile for all other arches...
