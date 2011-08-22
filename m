Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1HVNqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 09:46:44 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:52487 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1HVNqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 09:46:42 -0400
X-ASG-Debug-ID: 1314020801-03d6a50f480ba30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E525DBE.5020201@fusionio.com>
Date: Mon, 22 Aug 2011 15:46:38 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.1.0-rc2 block related lockdep report.
References: <20110819215754.GA12746@redhat.com>
X-ASG-Orig-Subj: Re: 3.1.0-rc2 block related lockdep report.
In-Reply-To: <20110819215754.GA12746@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1314020801
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.72503
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-19 23:57, Dave Jones wrote:
> Just got this while running kvm. (this is from the host)

This looks like a pcpu issue, not block related. We just happen to be
one of the users of it.

Regression?


-- 
Jens Axboe

