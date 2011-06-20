Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab1FTLXy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 07:23:54 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:33260 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab1FTLXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 07:23:52 -0400
X-ASG-Debug-ID: 1308569031-01de280c1e66f90001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DFF2DC4.50002@fusionio.com>
Date: Mon, 20 Jun 2011 13:23:48 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH reRESEND] block: add REQ_SECURE to REQ_COMMON_MASK
References: <1308278608-3284-1-git-send-email-namhyung@gmail.com> <1308280320-3510-1-git-send-email-namhyung@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH reRESEND] block: add REQ_SECURE to REQ_COMMON_MASK
In-Reply-To: <1308280320-3510-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1308569031
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.66597
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-17 05:12, Namhyung Kim wrote:
> Add REQ_SECURE flag to REQ_COMMON_MASK so that
> init_request_from_bio() can pass it to @req->cmd_flags.

Applied, thanks.

-- 
Jens Axboe

