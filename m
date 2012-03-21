Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030606Ab2CUKDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:03:46 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60573 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030290Ab2CUKDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:03:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] mfd: Add TWL4030 PWM driver
Date: Wed, 21 Mar 2012 10:03:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Bernhard Walle <bernhard@bwalle.de>, Bernhard Walle <walle@corscience.de>,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
References: <1332262083-9375-1-git-send-email-walle@corscience.de> <201203210839.06258.arnd@arndb.de> <20120321084856.GA17472@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20120321084856.GA17472@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203211003.28019.arnd@arndb.de>
X-Provags-ID: V02:K0:6jIaoZtmzQZmYTdsF4fVzaUR/zhuIdokMeFo9ymzM0j
 bblliMBAKPePaMzX6q74p19rtvp+JKAJ5gOwYubeOKjp3Jdo6S
 TRe/pIovJK8RN0QqET9IZNWi+aTf8Hnyt3jKMHu3+6KgLQztZu
 puMUDM7aLOIxfVUrfjnH+RJAfVJd+YNz/iNGnXYb4mOuO/vcco
 fda+4ZQOg/I8YE5NfItHpCtAUCmgIP72CSNggfzMo3K5iFyvCc
 inqOLoX9AwY6nojywupGrt1+yRxrC526IY/+pEt03u4W4sybP6
 nhQAq9hI12jg0q+IWySqIMU2WqStmiGJ3g7SKP8GX1CYyvt9H5
 GeYgr5H/7B4Z0SnuIJjY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 March 2012, Thierry Reding wrote:
> * Arnd Bergmann wrote:
> > On Wednesday 21 March 2012, Bernhard Walle wrote:
> > > Am 20.03.12 23:02, schrieb Arnd Bergmann:
> > > > On Tuesday 20 March 2012, Bernhard Walle wrote:
> > > >>
> > > >> This PWM driver uses the PWM of the TWL4030. The driver for the TWL6030
> > > >> PWM has been used as mode, but the PWM registers are different.
> > > >>
> > > >> The driver can be used and has been tested in conjunction with
> > > >> pwm-backlight to control a backlight LED of a LCD touch screen.
> > > >>
> > > >> Signed-off-by: Bernhard Walle <walle@corscience.de>
> > > > 
> > > > Since it's too late for v3.4 now and we will get a new pwm
> > > > subsystem in v3.5, I suggest you change the driver to work
> > > > register with that subsystem instead of just using the old
> > > > header file. Note that drivers/mfd is not really the right
> > > > place anyway, because this is not a multifunction driver but
> > > > just one device driver that happens to be a slave of an mfd.
> > > 
> > > Does that new subsystem already exist in some tree?
> >  
> > Thierry Reding has been busily posting patches, so he probably has
> > one that you can use, but I couldn't find it now.
> 
> I don't have a public tree anywhere. Does anyone have a recommendation where
> I could set one up? github or gitorious are the first to come to my mind.

They both work fine and are easy to set up, at least as a temporary location.

If you want to have something more official in the long run, you could
either set up your own git server on your employer's domain or if that
is impractical, get an account on kernel.org or linaro.org. Both of those
try to limit the amount of accounts they hand out to external people, but
since you are going to be a subsystem maintainer, I don't see it as a
problem.

	Arnd
