Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2ISRLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:11:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34751 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab2ISRLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:11:32 -0400
Date: Wed, 19 Sep 2012 10:11:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, arnd@arndb.de, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between
 DT and non-DT boots
Message-ID: <20120919171126.GA16730@core.coreip.homeip.net>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdaKa=NAObnjJyifhxyqu3Hcgj7Fxqi=bdNFqbm7V_8cSw@mail.gmail.com>
 <20120914080347.GB3374@gmail.com>
 <CACRpkdbntZ2k+2mi7=nCL2RV+YcbYi=wbK2RaDKsKNKqsCxMOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbntZ2k+2mi7=nCL2RV+YcbYi=wbK2RaDKsKNKqsCxMOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 01:22:06PM +0200, Linus Walleij wrote:
> On Fri, Sep 14, 2012 at 10:03 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Thu, Sep 13, 2012 at 11:35:43AM +0200, Linus Walleij wrote:
> >>
> >> Not having this patch in v3.6-rcN gives the following boot noise (and
> >> the key does not work):
> >>
> >> ------------[ cut here ]------------
> >> WARNING: at /home/elinwal/linux-stericsson/kernel/irq/irqdomain.c:137
> >> irq_domain_legacy_revmap+0x20/0x48()
> (...)
> > I haven't tested this, but I think this patch should be pulled out
> > of -next and pushed into the -rcs to fix the issue you see above.
> > The real fix along with the revert to this patch also resides in
> > -next and will be applied during the next merge window.
> 
> Dmitry, can you fix this?
> 
> v3.6-rc6 is regressing on us...

OK, I'll revert and send a pull request tonight.

Thanks.

-- 
Dmitry
