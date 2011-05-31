Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1EaLqc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 07:46:32 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:40430 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab1EaLqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 07:46:31 -0400
X-ASG-Debug-ID: 1306842390-03d6a512a921170001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DE4D514.3060207@fusionio.com>
Date: Tue, 31 May 2011 13:46:28 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] block: remove unwanted semicolons
References: <1306842293-17108-1-git-send-email-namhyung@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH RESEND] block: remove unwanted semicolons
In-Reply-To: <1306842293-17108-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306842390
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.65192
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-31 13:44, Namhyung Kim wrote:
> Since those defined functions require additional semicolon
> from the caller, they could cause potential syntax errors
> when used in if-else statements.

Applied, thanks.

-- 
Jens Axboe

