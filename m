Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758330Ab2CBJmM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:42:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:43678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339Ab2CBJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:42:08 -0500
Message-ID: <4F5095D6.1090806@kernel.dk>
Date: Fri, 02 Mar 2012 10:41:42 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
CC: Luis Henriques <luis.henriques@canonical.com>, Tejun Heo <tj@kernel.org>,
        Naveen Goswamy <naveen.goswamy@polymtl.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca> <20120212220836.6aa7fa4d@stein> <20120212222027.71651e8b@stein> <20120213021813.GA589@redhat.com> <1329154831.4f394b0f3c69c@www.imp.polymtl.ca> <4F3A4220.4010901@ce.jp.nec.com> <20120214162858.GM12117@google.com> <4F3B1ED3.4000706@ce.jp.nec.com> <20120215172617.GB24986@google.com> <4F3C5B4E.3080606@ce.jp.nec.com> <20120301185817.GA16253@zeus> <4F501052.5070301@ce.jp.nec.com>
In-Reply-To: <4F501052.5070301@ce.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2012 01:12 AM, Jun'ichi Nomura wrote:
> Hi,
> 
> On 03/02/12 03:58, Luis Henriques wrote:
>> Are there any updates on this fix?  I was wondering if any progress has been
>> made and if this patch has any chances of hitting mainline soon.
>>
>> I have executed a quick test and it seems to solve the problem (or, at least, I
>> am not able to reproduce the oops anymore).
> 
> Thank you for testing and feedback.
> 
> The patch is posted here and waiting for Jens to pick up:
>   https://lkml.org/lkml/2012/2/21/443
>   [PATCH] Fix NULL pointer dereference in sd_revalidate_disk

It's queued up, I'll send off patches to Linus today.

-- 
Jens Axboe

