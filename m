Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab2BAQ6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 11:58:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:49674 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2BAQ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 11:58:15 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: Adding remoteproc/rpmsg to linux-next
Date: Wed, 1 Feb 2012 16:57:36 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Brian Swetland <swetland@google.com>, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>
References: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com> <201112221522.21146.arnd@arndb.de> <CAK=WgbZK_fS_rPWZ9pNARia3sp4+jL5GmR0UmyE59WZSObfWEQ@mail.gmail.com>
In-Reply-To: <CAK=WgbZK_fS_rPWZ9pNARia3sp4+jL5GmR0UmyE59WZSObfWEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202011657.36998.arnd@arndb.de>
X-Provags-ID: V02:K0:xgCmVQi9zVVcxT4tWDvPukEaiOBVRUYSns8PUg5Pi8A
 QMrTnfjyUq58sYAkG3gSMFcpNMQO0MpOHJXQ9+Xe8cgc9dV4NB
 VftqgwjODox8DhTVWHDm9BmEvDOu6OTFisB6E1i43cHLQOAcY2
 dMd3uxIPVkxxeVUaOyfaMhsBWCmvkfTiJHR7kT5xRhZoIh5rFa
 tYmPEhi4pEJmDWRs57AypfICO6qRVpNSwl0QnxW7MC1tGcgfOZ
 4CuvEsv/qzvRcfQy0dr/03hokIoGGqISUmD52TxFAgkbr9+V9P
 EdZRfRN210rsKYbJTjvk/ABll9IW6CccwIETJSMuxcNa54PSRq
 UD4H+SRG25HlUcS+mugc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 February 2012, Ohad Ben-Cohen wrote:
> On Thu, Dec 22, 2011 at 5:22 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > If you think you need more Acks or if there are other
> > reasons to have it go through arm-soc, please tell me and I'll try harder
> > to find the time for a proper review.
> 
> Any chance you could carve out some time for reviewing remoteproc and
> rpmsg [1] ?

I will.
 
> I hope we could either get your Acks on the patches or even have it go
> through arm-soc for 3.4.

Yes, I think it's best to have it merged through arm-soc, in case Linus
is more likely to take it from there than pull from your tree.

	Arnd
