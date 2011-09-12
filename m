Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429Ab1ILS0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 14:26:00 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:56049 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1ILSZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:25:56 -0400
X-ASG-Debug-ID: 1315851946-01de285e7b46590001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E6E4EA5.1050701@fusionio.com>
Date: Mon, 12 Sep 2011 20:25:41 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com> <4E44E782.7090309@fusionio.com> <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com> <20110909085433.GA9593@infradead.org> <4E69D519.8070802@fusionio.com> <20110912150228.GA5771@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
In-Reply-To: <20110912150228.GA5771@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1315851946
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.74330
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-09-12 17:02, Christoph Hellwig wrote:
> On Fri, Sep 09, 2011 at 10:58:01AM +0200, Jens Axboe wrote:
>>>    Documentation/block/writeback_cache_control.txt file is the canonical
>>>    resource.  Implementing your driver at the make_request layer
>>>    unfortunately means you will have to do all the hard work yourself.
>>>  - also the call to blk_queue_flush(queue, 0); from ->make_request for
>>>    a non-data request is completely wrong.
>>
>> I noticed both of these flush/fua problems too and have fixed them up.
> 
> I still can't find any fixes in your repository.

It wasn't/isn't done, it's still sitting on the test box. I'll wrap it
up tomorrow.


-- 
Jens Axboe

