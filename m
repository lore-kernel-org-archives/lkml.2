Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458Ab2HXQOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:14:23 -0400
Received: from mail1-hoer.fullrate.dk ([89.150.129.84]:63261 "EHLO
	smtp.fullrate.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759647Ab2HXQOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:14:20 -0400
From: Martin Nybo Andersen <tweek@tweek.dk>
To: wbrana <wbrana@gmail.com>
Subject: Re: Drop support for x86-32
Date: Fri, 24 Aug 2012 18:14:16 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc2+; KDE/4.8.4; i686; ; )
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com> <1345823281.28613.34.camel@thorin> <CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com>
In-Reply-To: <CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208241814.16862.tweek@tweek.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 17:55:08 wbrana wrote:
> On 8/24/12, Bernd Petrovitsch <bernd@petrovitsch.priv.at> wrote:
> > You really think that there are no 32bit x86-compatible CPUs in the
> > embedded world?
> 
> x86-32 would be supported by long term tree until all x86-32 CPU disappear

Ahh..., so the development time saved by not supporting x86-32 in mainline can 
now be used by backporting new features to the forementioned long term tree?

(And I'm still not sure why one would run 32-bit applications on a 64-bit 
architecture...)

-- 
Cheers,
Martin
