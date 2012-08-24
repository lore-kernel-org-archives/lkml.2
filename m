Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819Ab2HXQRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 12:17:18 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:33157 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759655Ab2HXQRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 12:17:15 -0400
MIME-Version: 1.0
In-Reply-To: <201208241814.16862.tweek@tweek.dk>
References: <CAJ7jCmmbiR7Kzwtc4x++Z+onvSMN5ZyVrORiux6TuZ6=gCBH9Q@mail.gmail.com>
	<1345823281.28613.34.camel@thorin>
	<CAJ7jCmmYdQacFtzw+ukGAtrUntnn8S869RcCmbt3cVRY7HYOWw@mail.gmail.com>
	<201208241814.16862.tweek@tweek.dk>
Date: Fri, 24 Aug 2012 18:17:14 +0200
Message-ID: <CAJ7jCmkpvrX87T06JPHk4cShxaC=fUmkxGQmiHsKGwe+X2RVow@mail.gmail.com>
Subject: Re: Drop support for x86-32
From: wbrana <wbrana@gmail.com>
To: Martin Nybo Andersen <tweek@tweek.dk>
Cc: Bernd Petrovitsch <bernd@petrovitsch.priv.at>,
        Ondrej Zary <linux@rainbow-software.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/12, Martin Nybo Andersen <tweek@tweek.dk> wrote:
> Ahh..., so the development time saved by not supporting x86-32 in mainline
> can
> now be used by backporting new features to the forementioned long term
> tree?
new features won't be backported
