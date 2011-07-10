Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747Ab1GJUHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:07:49 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:42005 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133Ab1GJUHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:07:48 -0400
X-ASG-Debug-ID: 1310328467-03d6a510a9140ca0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E1A0690.3080404@fusionio.com>
Date: Sun, 10 Jul 2011 22:07:44 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Justin TerAvest <teravest@google.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] cfq: Remove special treatment for metadata rqs.
References: <1308603796-11074-1-git-send-email-teravest@google.com> <20110709110238.GA29082@infradead.org>
X-ASG-Orig-Subj: Re: [PATCH v2] cfq: Remove special treatment for metadata rqs.
In-Reply-To: <20110709110238.GA29082@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1310328467
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.68545
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-09 13:02, Christoph Hellwig wrote:
> Jens, any plans to pick this up?  Beeing able to just tag requests
> as metadata without side effects would really help us fs developers
> to be able to make more sense of blktrace output.

Yes, I agree. v2 looks fine, I'll pick it up for 3.1. Thanks Justin.

-- 
Jens Axboe

