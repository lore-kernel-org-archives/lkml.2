Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1JBShQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:37:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61706 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697Ab1JBShM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:37:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 02/26] sound/pxa-zylonite: use a valid device for dev_err()
Date: Sun, 02 Oct 2011 20:36:14 +0200
Message-ID: <2376094.AH5MH8IXqN@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002181611.GA2857@opensource.wolfsonmicro.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-3-git-send-email-arnd@arndb.de> <20111002181611.GA2857@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:6sRvu/rEyaY7CNcmMLpLC758FMCoLJzGJPNwff4nSMC
 PH3foyxRorPp/TECFBxWdb9aCvhBZx49u2TbXVcZzuppnqMA7h
 CiHlrTqZE8XGSB3YYvBiLrXQyUTOwP+2/kqLN6vqBZT6QKy65S
 8R5mECj0D/UjukcsRqe0tAkLawvtnKwop8gGajO1FmLjL8aDAM
 Ny2qXT71g/w80nSZZeZ8NyWxmYE8xP7Xi7NbW5nzqTZXcbC07i
 toTt7Dd6p287jfW/Srdxgi4kaKI/7j0yJHP2Nj/9V6jiQMHi6J
 gXzyTXIY8NuWoChl7R7VoRsSzuqU4DQWJDDZ/Gb3jEHCToVrlp
 Zoq85+nFvx3GCJ7DsvJ4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 19:16:11 Mark Brown wrote:
> On Sat, Oct 01, 2011 at 10:03:34PM +0200, Arnd Bergmann wrote:
> > A recent conversion has introduced references to &pdev->dev, which does
> > not actually exist in all the contexts it's used in.
> 
> > Replace this with card->dev where necessary, in order to let
> > the driver build again.
> 
> Applied, thanks.  I'm a bit confused about why this is buried in the
> middle of some enormous series of some kind?

The series is about trivial build fixes that are specific to pxa.
I was expecting most of them to go through the pxa tree because
I figured out would be easier to keep them together like this.

I also have a few sound/soc fixes in the respective samsung and
omap series, so if you prefer I can move them to a sound/soc
series and submit them all at once to you instead.

> Oh, and please do try to use subject lines which match up with the rest
> of the code you're patching - in this case it even looks like whatever
> you're using to autogenerate is misfiring as you've got a combination of
> - and / in filenames.

The subject line was hand-written, any problem in there is purely
my own. What is the naming you want for sound/soc, should I use
"ASoC: pxa-zylonite:" or "sound/soc/pxa/zylonite:" or something
else?

	Arnd
