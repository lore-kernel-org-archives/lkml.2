Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2IYPUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:20:49 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:34731 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754594Ab2IYPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:20:47 -0400
MIME-Version: 1.0
In-Reply-To: <20120925151103.GB18777@kroah.com>
References: <20120925161355.06cfe875c78bc163b050ed8c@canb.auug.org.au>
	<20120925151103.GB18777@kroah.com>
Date: Tue, 25 Sep 2012 18:20:46 +0300
Message-ID: <CAGF5oy_4W0smcW=-QthK6Xr1i3e6+kQz+_Tc2qUPqGROfhvhDA@mail.gmail.com>
Subject: Re: linux-next: manual merge of the staging tree with the thermal tree
From: "Valentin, Eduardo" <eduardo.valentin@ti.com>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Durgadoss R <durgadoss.r@intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 25, 2012 at 6:11 PM, Greg KH <greg@kroah.com> wrote:
>
> On Tue, Sep 25, 2012 at 04:13:55PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> >
> > Today's linux-next merge of the staging tree got a conflict in
> > drivers/staging/omap-thermal/omap-thermal-common.c between commit
> > 82d3a76a88cd ("Thermal: Pass zone parameters as argument to
> > tzd_register") from the thermal tree and commit 765a1939a364 ("staging:
> > omap-thermal: fix polling period settings") from the staging tree.
> >
> > I just used the thermal tree version and can carry the fix as necessary
> > (no action is required).
>
> That sounds correct to me, thanks.


Sounds good to me as well.

>
> greg k-h




--

Eduardo Valentin
