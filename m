Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab1DDUSX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:18:23 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:46779 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846Ab1DDUSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 16:18:21 -0400
X-Greylist: delayed 2149 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Apr 2011 16:18:21 EDT
Date: Mon, 4 Apr 2011 20:47:16 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 2.6.39-rc1 from commit
	7eaceaccab5f40bbfda044629a6298616aeaed50
Message-ID: <20110404194716.GB8785@sucs.org>
References: <4D9A0D97.1060505@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9A0D97.1060505@lwfinger.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 01:27:35PM -0500, Larry Finger wrote:
> After I pulled 2.6.39-rc1, my HP laptop failed to boot by never advancing 
> past the device detection stage on my x86_64 system. The problem was 
> bisected, which led to:

Sounds like the same as http://marc.info/?t=130137969500005&r=1&w=2
("Commit 7eaceaccab5f40 causing boot hang.") ...

-- 
Sitsofe | http://sucs.org/~sits/
