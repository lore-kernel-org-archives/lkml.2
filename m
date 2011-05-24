Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940Ab1EXOqa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 10:46:30 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:39415 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab1EXOq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:28 -0400
X-ASG-Debug-ID: 1306248387-03d6a50f5817d80001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DDBC4BC.8000506@fusionio.com>
Date: Tue, 24 May 2011 16:46:20 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH 1/2] loop: limit 'max_part' module param to DISK_MAX_PARTS
References: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] loop: limit 'max_part' module param to DISK_MAX_PARTS
In-Reply-To: <1306247761-2246-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1306248387
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.64662
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 16:36, Namhyung Kim wrote:
> The 'max_part' parameter controls the number of maximum partition
> a loop block device can have. However if a user specifies very
> large value it would exceed the limitation of device minor number
> and can cause a kernel panic (or, at least, produce invalid
> device nodes in some cases).

Applied as well, ditto in the stable comment.

-- 
Jens Axboe

