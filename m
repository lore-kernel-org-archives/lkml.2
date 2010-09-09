Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab0III1a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 04:27:30 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41842 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab0III10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 04:27:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=iaBtY9NaWASUt5QzEhNMPqNm1BX9ICEekoh07VhOr4oz4Nvq/md5wr+qmrGQ2unPkB
         yxZ8hkq1AKqw+QbcZRdAnikLxsMDR8F+SN5fkkU22sXEINVz2SU2qX8yKuwSNHHBYmmd
         mqwNNDrJC36BQMUBKWdnvoiIu7ErSz4mIJ67o=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v2] Input: Make ADS7846 independent on regulator
Date: Thu, 9 Sep 2010 10:27:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-1-amd64; KDE/4.4.5; x86_64; ; )
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, vapier@gentoo.org,
        khilman@deeprootsystems.com, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, pavel@ucw.cz,
        linux-input@vger.kernel.org, eric.y.miao@gmail.com,
        akpm@linux-foundation.org
References: <1280560182-7071-1-git-send-email-marek.vasut@gmail.com> <4C862EB3.4080006@compulab.co.il> <20100907125335.GD25830@sirena.org.uk>
In-Reply-To: <20100907125335.GD25830@sirena.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009091027.18176.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Út 7. září 2010 14:53:35 Mark Brown napsal(a):
> On Tue, Sep 07, 2010 at 03:23:15PM +0300, Igor Grinberg wrote:
> >  Seems that there are some more platforms then Sharp Zaurus
> > 
> > are interested in this patch.
> > 
> > Dmitry, Mike, Pavel,
> > 
> > What's the status of it?
> 
> From a regulator API usage point of view a separate implementation of
> the same thing was nacked - there are regulator API facilties for hiding
> missing regulators from drivers when needed to get systems going, unless
> the device genuinely can cope without supplies it should be relying on
> those.

Maybe these platforms should have been fixed prior to applying the patch adding 
regulator goo into ads7846 driver then. What's the way to go now then ?

Thanks, Cheers
