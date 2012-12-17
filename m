Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2LQVII (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:08:08 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49951 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab2LQVIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:08:05 -0500
Date: Mon, 17 Dec 2012 22:08:02 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Joe Perches <joe@perches.com>, Doug Thompson <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] MCE, AMD: Make MC2 decoding part of amd_decoder_ops
 as well
Message-ID: <20121217210802.GI31866@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, Joe Perches <joe@perches.com>,
	Doug Thompson <dougthompson@xmission.com>,
	linux-edac@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1355773188-5241-1-git-send-email-jacob.shin@amd.com>
 <1355774221.13361.48.camel@joe-AO722>
 <20121217200535.GF31866@liondog.tnic>
 <1355775376.19706.1.camel@joe-AO722>
 <20121217202214.GG31866@liondog.tnic>
 <1355776475.19706.6.camel@joe-AO722>
 <20121217204011.GH31866@liondog.tnic>
 <20121217204317.GA32760@jshin-Toonie>
 <1355777940.19706.11.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1355777940.19706.11.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 12:59:00PM -0800, Joe Perches wrote:
> The new pr_emerg is effectively a termination of the
> previous one.  There's no need for 2 consecutive uses
> of pr_emerg(HW_ERR ...) here.

Actually, in decode_mc5_mce(), the second pr_emerg needs to stay like
what it is now.

So Jacob, please leave those changes out, I'll sort them out later.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
