Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755831Ab0GEKdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 06:33:41 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43685 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab0GEKdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 06:33:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=u9yG9JEPyZ7RR3Eo1Rh63XXlEDMCqXHNB0/CywHhRxE2fqSVGbLVZbHneM0fX0T6ol
         ui53tjYb21v0Phj2E2gGRHeAfKqD19K9mE9J8J8jDUI3S0FGawYZFBK47Xw+6iSgnSIa
         HGgga32ekrq+roEqWGErqSTmfgH7ly45ZEb+c=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 17/33] Removing dead SX1_OLD_FLASH
Date: Mon, 5 Jul 2010 12:31:13 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33-2-amd64; KDE/4.4.3; x86_64; ; )
Cc: Christoph Egger <siccegge@cs.fau.de>,
       Russell King <linux@arm.linux.org.uk>, Kalle Valo <kalle.valo@iki.fi>,
       Ladislav Michl <ladis@linux-mips.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>, linux-omap@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
References: <cover.1277911345.git.siccegge@cs.fau.de> <201006302024.47025.marek.vasut@gmail.com> <20100705083346.GI15951@atomide.com>
In-Reply-To: <20100705083346.GI15951@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201007051231.14171.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Po 5. července 2010 10:33:48 Tony Lindgren napsal(a):
> * Marek Vasut <marek.vasut@gmail.com> [100630 21:21]:
> > Dne St 30. června 2010 17:59:25 Christoph Egger napsal(a):
> > > SX1_OLD_FLASH doesn't exist in Kconfig, therefore removing all
> > > references for it from the source code.
> > 
> > There were two models of the phone made, you can toggle between old and
> > new version. Maybe better documentation won't hurt.
> 
> Sounds like this should be done dynamically based on omap_rev,
> or some cmdline option from the bootloader? Not applying this
> one.
> 
> Tony

Yea, the russian guy who ported this is gone I guess though. Just maybe I can 
get my hands on linux-powered SX1 and try looking into this, but I can't promise 
it'll be any soon.

Cheers
