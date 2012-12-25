Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab2LYLNy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 06:13:54 -0500
Received: from mail.skyhub.de ([78.46.96.112]:36233 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab2LYLNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 06:13:51 -0500
Date: Tue, 25 Dec 2012 12:13:41 +0100
From: Borislav Petkov <bp@alien8.de>
To: wei_wang@realsil.com.cn
Cc: cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
Subject: Re: [PATCH v2 3/8] MFD:rtsx: Declare that the DMA address limitation
 is 32bit explicitly
Message-ID: <20121225111341.GE7692@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, wei_wang@realsil.com.cn,
	cjb@laptop.org, sameo@linux.intel.com, devel@linuxdriverproject.org,
	linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
	gregkh@linuxfoundation.org, arnd@arndb.de, oakad@yahoo.com
References: <cover.1356403281.git.wei_wang@realsil.com.cn>
 <7ba22b7e0e0be5a353cdfcfefbeff03a5be973c0.1356403281.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <7ba22b7e0e0be5a353cdfcfefbeff03a5be973c0.1356403281.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 25, 2012 at 10:43:09AM +0800, wei_wang@realsil.com.cn wrote:
> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>

This one is still missing a commit message. You might want to write some
blubber about the hardware supporting only 32-bit DMA or whatever the
real reason is.

Also, with the whole patchset, please don't send it the very next day
but do wait a couple of days to collect all feedback from people -
especially now I'd wait even longer since everyone except you and me are
away :) - and then resend it after incorporating all feedback.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
