Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2FKN14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:27:56 -0400
Received: from merlin.infradead.org ([205.233.59.134]:42843 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab2FKN1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:27:55 -0400
Message-ID: <1339421268.30462.15.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhouping Liu <zliu@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jun 2012 15:27:48 +0200
In-Reply-To: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-06-08 at 21:38 -0400, Zhouping Liu wrote:
> # cat /sys/devices/system/node/node*/distance
> 10 17 17 24 24 24 30 30
> 18 10 30 18 18 24 24 24
> 18 24 10 24 24 17 30 30
> 24 18 23 10 24 17 17 30
> 24 17 24 24 10 18 30 18
> 31 24 17 18 18 10 24 24
> 30 24 30 17 24 24 10 18
> 30 24 30 24 17 24 17 10 

You have to be kidding me right? That thing is a complete trainwreck,
what idiot vendor did this?

If you boot that machine again, does it have the same stupid table or
are we staring at white-noise?
