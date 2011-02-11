Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab1BKKHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 05:07:38 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:55577 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab1BKKHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 05:07:36 -0500
X-ASG-Debug-ID: 1297418855-03d6a50f0d537f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D550AAC.1090708@fusionio.com>
Date: Fri, 11 Feb 2011 11:08:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Tejun Heo <tj@kernel.org>, "tytso@mit.edu" <tytso@mit.edu>,
        "djwong@us.ibm.com" <djwong@us.ibm.com>,
        "shli@kernel.org" <shli@kernel.org>, "neilb@suse.de" <neilb@suse.de>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "jack@suse.cz" <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kmannth@us.ibm.com" <kmannth@us.ibm.com>,
        "cmm@us.ibm.com" <cmm@us.ibm.com>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "rwheeler@redhat.com" <rwheeler@redhat.com>, "hch@lst.de" <hch@lst.de>,
        "josef@redhat.com" <josef@redhat.com>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
Subject: Re: [PATCH v2 2/2] block: share request flush fields with  elevator_private
References: <20110201185225.GT14211@htj.dyndns.org> <1296600373-6906-2-git-send-email-snitzer@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH v2 2/2] block: share request flush fields with  elevator_private
In-Reply-To: <1296600373-6906-2-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1297418855
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.55011
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-01 23:46, Mike Snitzer wrote:
> Flush requests are never put on the IO scheduler.  Convert request
> structure's elevator_private* into an array and have the flush fields
> share a union with it.
> 
> Reclaim the space lost in 'struct request' by moving 'completion_data'
> back in the union with 'rb_node'.

Thanks Mike, I've merged this one and v5 1/2 as well.

-- 
Jens Axboe

