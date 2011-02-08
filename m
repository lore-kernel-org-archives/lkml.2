Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab1BHIBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 03:01:21 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:46473 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752043Ab1BHIBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 03:01:20 -0500
X-ASG-Debug-ID: 1297152079-03d6a50f0a30de0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D50F88A.6010703@fusionio.com>
Date: Tue, 8 Feb 2011 09:02:18 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Chad Talbott <ctalbott@google.com>
CC: LKML <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Michael Rubin <mrubin@google.com>,
        Justin TerAvest <teravest@google.com>
Subject: Re: Target for blk-cgroup CFQ code
References: <AANLkTimrDXBjq5waZb6-5_Zb48Dfe+okt6LH0d16vc2b@mail.gmail.com>
X-ASG-Orig-Subj: Re: Target for blk-cgroup CFQ code
In-Reply-To: <AANLkTimrDXBjq5waZb6-5_Zb48Dfe+okt6LH0d16vc2b@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297152079
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.54716
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-07 22:59, Chad Talbott wrote:
> Hi Jens,
> 
> We're going to be sending some patches against CFQ that expand on the
> blk-cgroup functionality and I wanted to confirm that they should be
> against git://git.kernel.dk/linux-2.6-block.git

Correct

> Do you have any particular preferences (patch naming conventions,
> etc.) that differ from Linus' guidelines?

No, I pretty much follow the standard setup.

-- 
Jens Axboe

