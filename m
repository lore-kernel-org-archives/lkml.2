Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab1EYThk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:37:40 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:37470 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755319Ab1EYThi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:37:38 -0400
X-ASG-Debug-ID: 1306352257-01de28096b693d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDD5A7E.4030903@fusionio.com>
Date: Wed, 25 May 2011 21:37:34 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ondrej Zary <linux@rainbow-software.org>
CC: Tejun Heo <tj@kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] 2.6.39 breaks floppy
References: <201105252116.37839.linux@rainbow-software.org>
X-ASG-Orig-Subj: Re: [bisected] 2.6.39 breaks floppy
In-Reply-To: <201105252116.37839.linux@rainbow-software.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306352257
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 21:16, Ondrej Zary wrote:
> Hello,
> floppy stopped working in 2.6.39 (confirmed on two machines). 2.6.38 worked 
> fine. 
> /dev/fd0 is created but does not work (mdir says: "No such device or address", 
> mount says "/dev/fd0 is not a valid block device"). dmesg shows no errors:
> 
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> 
> Bisected it to 9fd097b14918875bd6f125ed699d7bbbba5893ee
> (block: unexport DISK_EVENT_MEDIA_CHANGE for legacy/fringe drivers)
> 
> Adding the removed line back to floppy.c fixes the problem.

Tejun?

-- 
Jens Axboe

