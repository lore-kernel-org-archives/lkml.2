Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262Ab2LTTRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 14:17:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34603 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab2LTTR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 14:17:27 -0500
Date: Thu, 20 Dec 2012 20:17:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/2] MCE, AMD: MCE decoding support for AMD Family 16h
Message-ID: <20121220191724.GF26635@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355864771-13839-1-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 03:06:09PM -0600, Jacob Shin wrote:
> The following patchset enables MCE decoding support for AMD Family 16h
> processors.
> 
> Changes in V2:
> * Changed if/else style and pr_cont usage per feedback from:
>   https://lkml.org/lkml/2012/12/17/365
> 
> * Merged f14h and f16h mc0 and mc2 decoding into common function per
>   feedback from: https://lkml.org/lkml/2012/12/18/269
> 
> * Fixed typo in INT_ERROR decoding.
> 
> Jacob Shin (2):
>   MCE, AMD: Make MC2 decoding part of amd_decoder_ops as well
>   MCE, AMD: MCE decoding support for AMD Family 16h

Ok, applied and pushed out to:

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git edac-for-3.9

Please take a look and give them a run.

Also, I have a python injection script with which you could test
your decoding code on F16h - no real MCEs are getting injected, but
software-only. Let me know if you want it and I'll dust it off and send
it to you along with instructions on how to use it.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
