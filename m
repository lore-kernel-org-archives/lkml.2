Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab2FLOJR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:09:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab2FLOJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:09:14 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Maya Erez <merez@codeaurora.org>
Cc: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v4 1/1] block: Add test-iosched scheduler
References: <1339491984-8462-1-git-send-email-merez@codeaurora.org>
	<1339491984-8462-2-git-send-email-merez@codeaurora.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 12 Jun 2012 10:09:11 -0400
In-Reply-To: <1339491984-8462-2-git-send-email-merez@codeaurora.org> (Maya
	Erez's message of "Tue, 12 Jun 2012 12:06:24 +0300")
Message-ID: <x4962awk4fs.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> writes:

> The test scheduler allows testing a block device by dispatching
> specific requests according to the test case and declare PASS/FAIL
> according to the requests completion error code

What sort of tests have you written that make use of this
infrastructure?

> @@ -1072,8 +1072,6 @@ struct request *blk_get_request(struct request_queue *q, int rw, gfp_t gfp_mask)
>  {
>  	struct request *rq;
>  
> -	BUG_ON(rw != READ && rw != WRITE);
> -

Please explain this.

Cheers,
Jeff
