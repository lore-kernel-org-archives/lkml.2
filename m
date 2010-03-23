Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab0CWN1W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 09:27:22 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51629 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab0CWN1V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 09:27:21 -0400
Date: Tue, 23 Mar 2010 14:27:19 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Pawel S <spawels13@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ben Gamari <bgamari.foss@gmail.com>,
       tytso <tytso@mit.edu>, Nick Piggin <npiggin@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
Message-ID: <20100323132719.GY5768@kernel.dk>
References: <8c4cf08c1003230428t274b8ca8y13d67d65b8830dd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c4cf08c1003230428t274b8ca8y13d67d65b8830dd7@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23 2010, Pawel S wrote:
> Hello
> 
> I am experiencing very similar issue. My system is a regular desktop
> PC and it suffers from very high I/O latencies (sometimes desktop
> "hangs" for eight seconds or more) when copying large files. I tried
> kernels up to 2.6.34-rc2, but without luck. This issue was raised at
> Phoronix forums and Arjan (from Intel) noticed it can be VM related:
> 
> http://www.phoronix.com/forums/showpost.php?p=114975&postcount=51
> 
> Here is my perf timechart where you can notice I/O "steals" CPU from
> the other tasks:
> 
> http://hotfile.com/dl/30596827/ebe566b/output.svg.gz.html

It's also been my sneaking suspicion that swap is involved. I had lots
of RAM in anything I use, even the laptop and workstation. I'll try and
run some tests with lower memory and force it into swap, I've seen nasty
hangs that way.

-- 
Jens Axboe

