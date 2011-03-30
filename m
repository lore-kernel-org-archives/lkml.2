Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787Ab1C3KVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:21:18 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:55644 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1C3KVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:21:17 -0400
X-ASG-Debug-ID: 1301480476-03d6a569fb1e1b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D93041A.3030100@fusionio.com>
Date: Wed, 30 Mar 2011 12:21:14 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>
CC: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "oleg@redhat.com" <oleg@redhat.com>
Subject: Re: [PATCH] blk-throttle: don't call xchg on bool
References: <1292447255-10698-1-git-send-email-vgoyal@redhat.com>	<1292447255-10698-3-git-send-email-vgoyal@redhat.com> <m21v1ph639.fsf_-_@igel.home>
X-ASG-Orig-Subj: Re: [PATCH] blk-throttle: don't call xchg on bool
In-Reply-To: <m21v1ph639.fsf_-_@igel.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301480476
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59395
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-30 01:14, Andreas Schwab wrote:
> xchg does not work portably with smaller than 32bit types.

Thanks Andreas, I guess if people look at the x86 implementation then
that's a worry.

-- 
Jens Axboe

