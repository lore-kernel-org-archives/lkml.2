Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760643Ab0KRV2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:28:19 -0500
Received: from mail.wdtv.com ([66.118.69.84]:37266 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759943Ab0KRV2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:28:18 -0500
From: Gene Heskett <gene.heskett@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: Galbraith patch
Date: Thu, 18 Nov 2010 16:28:13 -0500
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.3; i686; ; )
Cc: Thomas Backlund <tmb@mandriva.org>, LKML <linux-kernel@vger.kernel.org>
References: <1290018947.4887.14.camel@note-311a> <4CE5731B.20807@mandriva.org> <1290110456.10702.12.camel@maggy.simson.net>
In-Reply-To: <1290110456.10702.12.camel@maggy.simson.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201011181628.13324.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 18, 2010, Mike Galbraith wrote:
>On Thu, 2010-11-18 at 20:40 +0200, Thomas Backlund wrote:
>> and more importantly it misses theese:
>Heh.  Apply the attached, autogroup last.

Still incomplete I'd guess.  From the make bzimage:
In file included from kernel/sched.c:1931:
kernel/sched_autogroup.c: In function ‘autogroup_create’:
kernel/sched_autogroup.c:56: error: ‘struct task_group’ has no member named 
‘autogroup’


-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
We gave you an atomic bomb, what do you want, mermaids?
		-- I. I. Rabi to the Atomic Energy Commission
