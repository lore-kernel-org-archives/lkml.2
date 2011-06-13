Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751573Ab1FMJsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:48:10 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42842 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab1FMJsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:48:03 -0400
X-ASG-Debug-ID: 1307958482-03d6a510a823370001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DF5DCCE.8070100@fusionio.com>
Date: Mon, 13 Jun 2011 11:47:58 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "adobriyan@gmail.com" <adobriyan@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>
Subject: Re: [PATCH] fs/partitions/check.c: make local symbols static
References: <201106101526.59686.hartleys@visionengravers.com>
X-ASG-Orig-Subj: Re: [PATCH] fs/partitions/check.c: make local symbols static
In-Reply-To: <201106101526.59686.hartleys@visionengravers.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1307958482
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.41
X-Barracuda-Spam-Status: No, SCORE=0.41 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=SUBJECT_FUZZY_TION
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65981
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.41 SUBJECT_FUZZY_TION     Attempt to obfuscate words in Subject:
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-11 00:26, H Hartley Sweeten wrote:
> The symbols part_ro_show, part_alignment_offset_show, and
> part_discard_alignment_show are not used outside this file and
> should be marked static.

Applied, thanks.

-- 
Jens Axboe

