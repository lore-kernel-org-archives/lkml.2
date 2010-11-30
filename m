Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab0K3Wz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 17:55:28 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:34672 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab0K3WzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 17:55:20 -0500
X-ASG-Debug-ID: 1291146626-28067-205666-1
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4CF5557E.70600@fusionio.com>
Date: Tue, 30 Nov 2010 20:50:22 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmoyer@redhat.com" <jmoyer@redhat.com>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "jmarchan@redhat.com" <jmarchan@redhat.com>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of small fixes
References: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] blk-throttle: Couple of small fixes
In-Reply-To: <1291136157-2732-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1291146626
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Orig-Rcpt: oleg@redhat.com,jmarchan@redhat.com,jmoyer@redhat.com,
	vgoyal@redhat.com,linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-30 17:55, Vivek Goyal wrote:
> Hi Jens,
> 
> During some testing and discussions with Oleg, two bugs were noticed with
> block throttle code. Please find attached the fixes. These are small fixes
> and I did not notice any side affects during my testing.

I never seemed to receive 2/2, did it get lost?

-- 
Jens Axboe

