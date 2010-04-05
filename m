Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab0DEC1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 22:27:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:52577 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab0DEC1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 22:27:49 -0400
Message-ID: <4BB94A9A.5090808@kernel.org>
Date: Mon, 05 Apr 2010 11:27:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH 05/17] staging: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>	<1269885165-18617-6-git-send-email-tj@kernel.org> <20100403123629.d1148066.sfr@canb.auug.org.au>
In-Reply-To: <20100403123629.d1148066.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 05 Apr 2010 02:27:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/03/2010 10:36 AM, Stephen Rothwell wrote:
> On Tue, 30 Mar 2010 02:52:33 +0900 Tejun Heo <tj@kernel.org> wrote:
>>
>>  drivers/staging/comedi/drivers/quatech_daqp_cs.c |    1 +
>>  drivers/staging/otus/usbdrv.h                    |    1 +
> 
> The changes to those two files are fixes mainline so should go into your
> slabh tree.

The first one is false positive caused by addition of semaphore.h
inclusion in linux-next transiting quatech_daqp_cs.c from ERR to auto
edit candidate.

I applied the second one to slabh.  I'll also pull in -rc3 and do some
merge testing.  If nothing else breaks, I'll ask Linus to pull in
slabh.

Thanks.

-- 
tejun
