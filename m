Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab0GHIxX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:53:23 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39731 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab0GHIxW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:53:22 -0400
Message-ID: <4C359200.8070105@kernel.dk>
Date: Thu, 08 Jul 2010 10:53:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/7] block: BKL removal, version 4
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <4C34D74A.4060308@kernel.dk> <201007072218.24013.arnd@arndb.de>
In-Reply-To: <201007072218.24013.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-07 22:18, Arnd Bergmann wrote:
> On Wednesday 07 July 2010 21:36:42 Jens Axboe wrote:
>> I'll go over each one tomorrow and add the series.
> 
> Ok, thanks!
> 
> If it makes your life easier, feel free to get this series from
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/arnd/bkl.git block

I applied it manually with the fixups mention, one of them also needed
a bit of hand holding (applying with fuzz). The end result looks good
and it survives an allmodconfig at least.

-- 
Jens Axboe

