Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab1DAWlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 18:41:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10436 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758810Ab1DAWlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 18:41:07 -0400
Date: Fri, 1 Apr 2011 18:41:00 -0400
From: Dave Jones <davej@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: GPF in __call_for_each_cic
Message-ID: <20110401224059.GA2050@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110331223034.GA31371@redhat.com>
 <4D95D630.4010806@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D95D630.4010806@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 03:42:08PM +0200, Jens Axboe wrote:

 > >  ---[ end trace 044e02f5767b491a ]---
 > >  Fixing recursive fault but reboot is needed!
 > 
 > This looks like the ellusive cic bug that has never been fixed and
 > strikes once in a blue moon. What was the system doing?
 
indeed, I've seen it before too.
first time I saw it, system was booting.
yesterdays hit was while syscall fuzzing sys_adjtimex (so the only
real io should have been the fuzzers own logging routines)

	Dave
