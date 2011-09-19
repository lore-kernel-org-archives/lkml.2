Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab1ISJyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 05:54:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab1ISJyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 05:54:21 -0400
Date: Mon, 19 Sep 2011 11:54:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
Cc: "'Larry Finger'" <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSN?= =?utf-8?Q?=3A?= 3.1-rc6+ rtl8192se issue
Message-ID: <20110919095421.GA3271@gere.osrc.amd.com>
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
 <20110916180323.GA1988@gere.osrc.amd.com>
 <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CD4D8CF16C39438E82FE8241C9AF80F4@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 12:43:45PM +0800, 李朝明 wrote:
> Dear sir:
> 
> 	Can you give me the screen pcitrue after crash again with ips = 0;
> or swlps=0 ips=0.
> 	Thank you!

I just started a "swlps=0 ips=0" test and will try to capture something
if the slowdown happens again - I can't promise you a whole stack trace
because the sysrq output doesn't fit on the screen fully...

Stay tuned.

-- 
Regards/Gruss,
Boris.
