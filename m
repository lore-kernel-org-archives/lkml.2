Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529Ab2JZLTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:19:15 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49034 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab2JZLTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:19:14 -0400
Date: Fri, 26 Oct 2012 04:16:50 -0700
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121026111621.GA2236@swordfish.minsk.epam.com>
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <CAFTL4hxmh7yV8ePUhY_7hOuG=JrbZZcNvV88bWcUmwG9X0W04A@mail.gmail.com>
 <20121025055056.GA2661@swordfish>
 <CAFTL4hxM8KqL3=GLkJDU-9pKVHrb1nSoDgFx8UVB7F7tryw6HA@mail.gmail.com>
 <20121025074147.GA2240@swordfish>
 <CAFTL4hw=orRVYzuk8L1aBHCxVD05uT_fdFoRJ_BkihoNd0huJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFTL4hw=orRVYzuk8L1aBHCxVD05uT_fdFoRJ_BkihoNd0huJg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/26/12 11:44), Frederic Weisbecker wrote:
> Thanks.
> 
> Sergey, Dave,
> 
> Does the patch I just sent you fix the issue?
> 
> Patch is "[PATCH] rcu: Fix unrecovered RCU user mode in syscall_trace_leave()"
>

good job, works fine for me.

Tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>


	-ss
 
> Thanks.
> 
