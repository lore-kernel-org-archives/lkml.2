Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761959Ab2COOBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 10:01:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759313Ab2COOBG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 10:01:06 -0400
Message-ID: <1331820051.18960.187.camel@twins>
Subject: Re: [PATCH] watchdog: Make sure the watchdog thread gets CPU on
 loaded system
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Don Zickus <dzickus@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>
Date: Thu, 15 Mar 2012 15:00:51 +0100
In-Reply-To: <20120315124228.GA5318@elte.hu>
References: <1331757525-5755-1-git-send-email-dzickus@redhat.com>
	 <20120314161906.e53359d3.akpm@linux-foundation.org>
	 <20120315014511.GT27051@google.com> <1331809239.18960.168.camel@twins>
	 <1331809597.18960.171.camel@twins> <20120315124228.GA5318@elte.hu>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-15 at 13:42 +0100, Ingo Molnar wrote:
> So unless there's concensus to remove everything but the hard 
> lockup detection facilities, lets solve the technical problem at 
> hand, ok? 

Well, at least make it possible to disable the silly soft thing.

And I really wouldn't know how the soft thing could possible help,
except when not actually having a NMI watchdog. What case does it
trigger where the NMI one doesn't?
