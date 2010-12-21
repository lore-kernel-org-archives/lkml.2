Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0LUOJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:09:12 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:41875 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0LUOJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:09:10 -0500
X-ASG-Debug-ID: 1292940547-2c9d312b0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D10B4E1.5070902@fusionio.com>
Date: Tue, 21 Dec 2010 15:08:33 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Clean up exit_io_context() source code.
References: <201012211318.47736.bvanassche@acm.org>
X-ASG-Orig-Subj: Re: [PATCH] block: Clean up exit_io_context() source code.
In-Reply-To: <201012211318.47736.bvanassche@acm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1292940547
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.3940 1.0000 -0.0156
X-Barracuda-Spam-Score: -0.02
X-Barracuda-Spam-Status: No, SCORE=-0.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.50080
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-21 13:18, Bart Van Assche wrote:
> This patch fixes a spelling error in a source code comment and removes
> superfluous braces in the function exit_io_context().

Thanks Bart, applied.

-- 
Jens Axboe

