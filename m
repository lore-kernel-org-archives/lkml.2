Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1CVU2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 16:28:00 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:58785 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754955Ab1CVU16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 16:27:58 -0400
X-ASG-Debug-ID: 1300825677-03d6a54f60bcf40001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D89064A.1080805@fusionio.com>
Date: Tue, 22 Mar 2011 21:27:54 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Justin TerAvest <teravest@google.com>
CC: "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] cfq: Fixes for unaccounted_time variable
References: <1300825050-11371-1-git-send-email-teravest@google.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] cfq: Fixes for unaccounted_time variable
In-Reply-To: <1300825050-11371-1-git-send-email-teravest@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300825677
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58669
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 21:17, Justin TerAvest wrote:
> This should fix both issues that Vivek pointed out:
>   * We can't set active queue at preempt time, because select queue
>     might select a different queue than the one we chose to preempt.
>   * Move the new variable to only be exported when debugging options are
>     on.

Thanks, applied.

-- 
Jens Axboe

