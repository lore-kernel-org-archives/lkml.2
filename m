Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759879Ab2HXQVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:21:02 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:51877 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759498Ab2HXQVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:21:00 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: wbrana <wbrana@gmail.com>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 18:20:54 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc2+; KDE/4.8.4; i686; ; )
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <201208241814.16862.tweek@tweek.dk> <CAJ7jCmkpvrX87T06JPHk4cShxaC=fUmkxGQmiHsKGwe+X2RVow@mail.gmail.com>
In-Reply-To: <CAJ7jCmkpvrX87T06JPHk4cShxaC=fUmkxGQmiHsKGwe+X2RVow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208241820.54778.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 18:17:14 wbrana wrote:
> On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> > Ahh..., so the development time saved by not supporting x86-32 in
> > mainline can
> > now be used by backporting new features to the forementioned long term
> > tree?
> 
> new features won't be backported

Ok. Seriously.

Dropping one of the most used architectures for no apparent reason makes no 
sense at all.

-- 
Cheers,
Martin
