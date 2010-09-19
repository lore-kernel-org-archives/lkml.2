Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab0ISNzZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 09:55:25 -0400
Received: from daytona.panasas.com ([67.152.220.89]:40136 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753374Ab0ISNzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 09:55:22 -0400
Message-ID: <4C961644.70209@panasas.com>
Date: Sun, 19 Sep 2010 15:55:16 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        James.Bottomley@suse.de, michaelc@cs.wisc.edu, konrad@darnok.org,
        jeykholt@cisco.com, hare@suse.de, hch@lst.de, James.Smart@Emulex.Com,
        andrew.vasquez@qlogic.com, philipp.reisner@linbit.com,
        martin.petersen@oracle.com, vasu.dev@linux.intel.com,
        Joel Becker <joel.becker@oracle.com>,
        Linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [ANNOUNCE] TCM/LIO v4.0.0-rc4 for 2.6.36-rc4
References: <1284754930.13344.216.camel@haakon2.linux-iscsi.org>	 <20100918125729D.fujita.tomonori@lab.ntt.co.jp> <1284841932.13344.339.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1284841932.13344.339.camel@haakon2.linux-iscsi.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Sep 2010 13:55:21.0627 (UTC) FILETIME=[4D1016B0:01CB5802]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/18/2010 10:32 PM, Nicholas A. Bellinger wrote:
> On Sat, 2010-09-18 at 13:00 +0900, FUJITA Tomonori wrote:
> So the RFC cuts have been going into a seperate tree here:
> 
> http://git.kernel.org/?p=linux/kernel/git/nab/lio-4.0.git;a=summary
> 

This is the two weeks ago stuff, right. Where is the lio-core-2.6.git/ ?

> Mike has requested an RFC v2 for him to review TCM Core and TCM_Loop
> v4.0.0-rc4 changes.  So I will be respinning this tree with the latest
> changes from lio-core-2.6.git/lio-4.0 and re-posting in the next days.
> 

Me to. And a git tree and a git web, as well. I'll postpone any review
to that time.

Thanks
Boaz
