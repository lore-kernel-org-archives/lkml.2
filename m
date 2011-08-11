Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1HKIg3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:36:29 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:43866 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1HKIg1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:36:27 -0400
X-ASG-Debug-ID: 1313051784-03d6a510a62981f0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E439485.9000106@fusionio.com>
Date: Thu, 11 Aug 2011 10:36:21 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: Christoph Hellwig <hch@lst.de>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/2] Move some REQ flags to the common bio/request area
References: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
X-ASG-Orig-Subj: Re: [PATCH 1/2] Move some REQ flags to the common bio/request area
In-Reply-To: <1312957924-2316-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1313051784
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71438
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-10 08:32, Namhyung Kim wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> REQ_SECURE, REQ_FLUSH and REQ_FUA may all be set on a bio as well as
> on a request, so relocate them to the shared part of the enum.

Thanks, applied.

-- 
Jens Axboe

