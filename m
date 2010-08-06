Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab0HFGaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:30:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:59433 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab0HFGaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:30:18 -0400
Message-ID: <4C5BABD3.6010303@kernel.org>
Date: Fri, 06 Aug 2010 08:29:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Tao Ma <tao.ma@oracle.com>
CC: Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <jens.axboe@kernel.dk>,
        stable@kernel.org, Vladislav Bolkhovitin <vst@vlnb.net>,
        Bryan Mesich <bryan.mesich@ndsu.edu>, scst-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, Neil Brown <neilb@suse.de>
Subject: Re: [PATCH RESEND 1/2 block#for-linus] bio, fs: update READA and
 SWRITE to match the corresponding BIO_RW_* bits
References: <20100628010346.GA2376@atlantis.cc.ndsu.nodak.edu>	<4C28EFD6.2070203@vlnb.net>	<20100714190325.GA25148@atlantis.cc.ndsu.nodak.edu>	<4C3EF3AD.5070509@vlnb.net>	<20100723191844.GB31152@atlantis.cc.ndsu.nodak.edu>	<4C4D7DF5.9060909@vlnb.net>	<20100727220110.GF31152@atlantis.cc.ndsu.nodak.edu>	<4C5073F3.1060406@vlnb.net> <4C52A98A.7060507@kernel.org>	<20100802104227.79340b49@notabene> <4C56D30A.3000403@kernel.org> <x49y6ckc302.fsf@segfault.boston.devel.redhat.com> <4C5B89DB.5050106@oracle.com>
In-Reply-To: <4C5B89DB.5050106@oracle.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 06 Aug 2010 06:29:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/06/2010 06:04 AM, Tao Ma wrote:
> If only this patch goes into stable, do we need to change RWA_MASK in this patch also(I have seen you change it the 2/2)?
> 
> -#define RWA_MASK        2
> +#define RWA_MASK        16

Yeah, Neil already pointed it out and updated patch has been posted
and merged.

Thanks.

-- 
tejun
