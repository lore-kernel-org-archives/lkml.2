Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759491Ab2CGQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 11:31:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553Ab2CGQb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 11:31:57 -0500
Message-ID: <1331137905.11248.355.camel@twins>
Subject: Re: runnable tasks never making it to a runqueue where they can run?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Roland Dreier <roland@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 07 Mar 2012 17:31:45 +0100
In-Reply-To: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
References: <CAL1RGDUbxcx+cCM_mf1nFJ=Jz0SyaiW0ffxiY4gZ6KNWzJCnMg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 18:19 -0800, Roland Dreier wrote:
> 6,7,8,10,18,19,22 but never onto 23

>   (Interestingly, those 8 CPUs seem to form a domain) 

That would be 'interesting'... I have a similar wsm box and you should
have a domain setup like:

0-5,12-17  (node 0)
6-11,18-23 (node 1)

Where the first set (0-5 & 6-11) is smt0 and the second set (12-17 &
18-23) smt1.

Can you boot with sched_debug and send me both /proc/cpuinfo and dmesg?
