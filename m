Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab2CBANM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:13:12 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:47786 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab2CBANL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:13:11 -0500
Message-ID: <4F501052.5070301@ce.jp.nec.com>
Date: Fri, 02 Mar 2012 09:12:02 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Luis Henriques <luis.henriques@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
CC: Tejun Heo <tj@kernel.org>, Naveen Goswamy <naveen.goswamy@polymtl.ca>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: Kernel crashing on eject SD card
References: <1328660390.4f31bfa6e8f4b@www.imp.polymtl.ca> <20120212220836.6aa7fa4d@stein> <20120212222027.71651e8b@stein> <20120213021813.GA589@redhat.com> <1329154831.4f394b0f3c69c@www.imp.polymtl.ca> <4F3A4220.4010901@ce.jp.nec.com> <20120214162858.GM12117@google.com> <4F3B1ED3.4000706@ce.jp.nec.com> <20120215172617.GB24986@google.com> <4F3C5B4E.3080606@ce.jp.nec.com> <20120301185817.GA16253@zeus>
In-Reply-To: <20120301185817.GA16253@zeus>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/02/12 03:58, Luis Henriques wrote:
> Are there any updates on this fix?  I was wondering if any progress has been
> made and if this patch has any chances of hitting mainline soon.
> 
> I have executed a quick test and it seems to solve the problem (or, at least, I
> am not able to reproduce the oops anymore).

Thank you for testing and feedback.

The patch is posted here and waiting for Jens to pick up:
  https://lkml.org/lkml/2012/2/21/443
  [PATCH] Fix NULL pointer dereference in sd_revalidate_disk

-- 
Jun'ichi Nomura, NEC Corporation
