Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2ALIQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 03:16:24 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39046 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698Ab2ALIQX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 03:16:23 -0500
Message-ID: <4F0E96C6.9060404@kernel.dk>
Date: Thu, 12 Jan 2012 09:16:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH] blockdev: convert some macros to static inlines
References: <20120112144215.595112f06f35d0072d5a334e@canb.auug.org.au> <yq1y5tdh8bu.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1y5tdh8bu.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 05:07 AM, Martin K. Petersen wrote:
>>>>>> "sfr" == Stephen Rothwell <sfr@canb.auug.org.au> writes:
> 
> sfr> We prefer to program in C rather than preprocessor and it fixes
> sfr> this warning when CONFIG_BLK_DEV_INTEGRITY is not set:
> 
> I have the patch below in my for-block queue but don't care much either
> way. Jens, which one do you prefer?

I'll take Stephens if you don't mind, I prefer the simplicity of just
typing out the functions.

-- 
Jens Axboe

