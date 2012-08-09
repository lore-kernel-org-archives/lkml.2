Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab2HINXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:23:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:59556 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269Ab2HINXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:23:50 -0400
Message-ID: <5023B9CD.2030004@kernel.dk>
Date: Thu, 09 Aug 2012 15:23:25 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org,
        Damien Wyart <damien.wyart@free.fr>, Li Shaohua <shli@fusionio.com>,
        Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] [RESEND] Remove plugging at buffered write time
References: <20120805082614.071671796@intel.com>
In-Reply-To: <20120805082614.071671796@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2012 10:26 AM, Fengguang Wu wrote:
> Hi all,
> 
> It seems this patch was silently forgotten, but the review comments have all
> been addressed: the patch has been split into two pieces and tests show no
> performance regressions (nor noticeable gains..).
> 
> Thanks to Damien for reminding me of the patch!

Thanks Wu, applied.

-- 
Jens Axboe

