Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab1IATrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 15:47:05 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:44043 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757563Ab1IATrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 15:47:03 -0400
X-ASG-Debug-ID: 1314906421-01de2813ab2ec00001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E5FE133.3060904@fusionio.com>
Date: Thu, 1 Sep 2011 13:46:59 -0600
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <x49y5y8xd4i.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
In-Reply-To: <x49y5y8xd4i.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314906421
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.73361
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-01 13:43, Jeff Moyer wrote:
> "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com> writes:
> 
>> New patch for mtip32xx driver based on feedback from
>> Jens Axboe, Christoph Hellwig, and Alan Cox.
> 
> Hi, Sam,
> 
> The patch is line-wrapped.  Could you fix your mailer settings and
> re-send?

JFYI, it's already queued up in a for-3.2/mtip32xx branch in my tree,
unwrapped. So might be easier to just take a peek there. Branch is
intended to be merged into for-3.2/drivers eventually.

-- 
Jens Axboe

