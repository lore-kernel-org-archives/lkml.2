Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab0JAAUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 20:20:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33015 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab0JAAUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 20:20:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=qP7qeDKML8svOWq33bF0BQ/AJncJVC6R8R5wHHWeY9jUqbq9NFejIavt2cFNO9gtDh
         VqeJVQBUGsb3NZx2FZ73rGXVxVNSqX05AaY3e87HLFeakqSD2JaEhiH1S7VAREwGmKrY
         m7cOJSGQp82VQ9mGlScLVVUJhE5zXfuOaBTXo=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Date: Fri, 1 Oct 2010 02:20:38 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com> <201009091027.18176.marek.vasut@gmail.com> <20100909094120.GB1988@rakim.wolfsonmicro.main>
In-Reply-To: <20100909094120.GB1988@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010010220.38321.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 9. září 2010 11:41:20 Mark Brown napsal(a):
> On Thu, Sep 09, 2010 at 10:27:17AM +0200, Marek Vasut wrote:
> > Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):
> > > From a regulator API usage point of view a separate implementation of
> > > the same thing was nacked - there are regulator API facilties for
> > > hiding missing regulators from drivers when needed to get systems
> > > going, unless the device genuinely can cope without supplies it should
> > > be relying on those.
> > 
> > Maybe these platforms should have been fixed prior to applying the patch
> > adding regulator goo into ads7846 driver then. What's the way to go now
> > then ?
> 
> Fix the platforms and use the dummy regulators to keep them going until
> that happens.  It's trivial to do the hookup in the platforms.

Igor, any update on this?

Thanks!
