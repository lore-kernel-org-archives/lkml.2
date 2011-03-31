Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab1CaPJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19560 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226Ab1CaPJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:09:52 -0400
Date: Thu, 31 Mar 2011 11:09:35 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption in
 today's -git)
Message-ID: <20110331150935.GC10163@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Tejun Heo <tj@kernel.org>
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <AANLkTikYAAYcYxTdKAxQjDxVQ7qrZGEfXg+gpfwcj1=-@mail.gmail.com>
 <20110331035511.GA1255@redhat.com>
 <AANLkTikP5edK=YSRx7zuNqyfwez8qEHpFumYun6GOPxu@mail.gmail.com>
 <20110331145850.GA10163@redhat.com>
 <20110331150344.GB10163@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110331150344.GB10163@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 11:03:44AM -0400, Dave Jones wrote:
 > On Thu, Mar 31, 2011 at 10:58:50AM -0400, Dave Jones wrote:
 >  
 > bah I missed a level. which seems to be the smoking gun.
 > something in the tty layer seems to have gone nuts.
 
I thought that trace looked familiar.

http://lkml.org/lkml/2010/11/30/592

It's the same thing.

	Dave

