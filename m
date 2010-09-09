Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0IIJl0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 05:41:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43035 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752443Ab0IIJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 05:41:22 -0400
Date: Thu, 9 Sep 2010 10:41:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Vasut <marek.vasut@gmail.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Message-ID: <20100909094120.GB1988@rakim.wolfsonmicro.main>
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com>
 <4C862EB3.4080006@compulab.co.il>
 <20100907125335.GD25830@sirena.org.uk>
 <201009091027.18176.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201009091027.18176.marek.vasut@gmail.com>
X-Cookie: Many suitcases look alike.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 10:27:17AM +0200, Marek Vasut wrote:
> Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):

> > From a regulator API usage point of view a separate implementation of
> > the same thing was nacked - there are regulator API facilties for hiding
> > missing regulators from drivers when needed to get systems going, unless
> > the device genuinely can cope without supplies it should be relying on
> > those.

> Maybe these platforms should have been fixed prior to applying the patch adding 
> regulator goo into ads7846 driver then. What's the way to go now then ?

Fix the platforms and use the dummy regulators to keep them going until
that happens.  It's trivial to do the hookup in the platforms.
