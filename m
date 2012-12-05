Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab2LETNf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 14:13:35 -0500
Received: from mx1.fusionio.com ([66.114.96.30]:49179 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab2LETNd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 14:13:33 -0500
X-ASG-Debug-ID: 1354734812-03d6a57f9b2953d0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <50BF9CD8.4020209@fusionio.com>
Date: Wed, 5 Dec 2012 20:13:28 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, Zach Brown <zab@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        "jeder@redhat.com" <jeder@redhat.com>
Subject: Re: [patch,v3] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
References: <x49ip8g9w66.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [patch,v3] bdi: add a user-tunable cpu_list for the bdi flusher
 threads
In-Reply-To: <x49ip8g9w66.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1354734812
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.116175
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-05 19:43, Jeff Moyer wrote:
> In realtime environments, it may be desirable to keep the per-bdi
> flusher threads from running on certain cpus.  This patch adds a
> cpu_list file to /sys/class/bdi/* to enable this.  The default is to tie
> the flusher threads to the same numa node as the backing device (though
> I could be convinced to make it a mask of all cpus to avoid a change in
> behaviour).

This looks fine to me now. I'll queue it up for 3.8.

-- 
Jens Axboe

