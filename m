Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760235Ab2EKOcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 10:32:18 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:57048 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760105Ab2EKOcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 10:32:16 -0400
X-ASG-Debug-ID: 1336746735-0421b516ea10100001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FAD22E6.4060702@fusionio.com>
Date: Fri, 11 May 2012 16:32:06 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch, v2] block: don't mark buffers beyond end of disk as mapped
References: <x49obq666i8.fsf@segfault.boston.devel.redhat.com> <x49d36ax372.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [patch, v2] block: don't mark buffers beyond end of disk as mapped
In-Reply-To: <x49d36ax372.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1336746735
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.96643
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 03:22 PM, Jeff Moyer wrote:
> Jens, could you please queue this patch up?

Yup will do, thanks!

-- 
Jens Axboe

