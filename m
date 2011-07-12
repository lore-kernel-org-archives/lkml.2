Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab1GLNCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:02:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:61672 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab1GLNCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:02:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/6] ARM: make mach/hardware.h optional
Date: Tue, 12 Jul 2011 15:02:41 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org,
        nico@fluxnic.net
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com> <201107021124.46953.arnd@arndb.de> <4E1B176E.3030503@gmail.com>
In-Reply-To: <4E1B176E.3030503@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107121502.41570.arnd@arndb.de>
X-Provags-ID: V02:K0:Opm5gNHeRaSZx9ymbTISPFfkv9/8uyeQU8/lxB2sBcx
 rxp9PyK3oGc0mFXErP556cQ+MkbYTcpgWGciIiN3C21iR0Duck
 2LOs4jOBJtQQ6BRuTh9Ds08d9m8QgAKiwgi44seEpRbSXusQsy
 2TbVO4f+DMyimf87AqsCQ4irKvKTEsS+qdjJnI8r3IS8SdGram
 fql4QS8ewMT9T+C0MuO4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 July 2011, Rob Herring wrote:
> > 
> > This is very good work, I really like it. I've mentioned one idea for
> > an improvement in patch 5, which you can still integrate, but otherwise
> > 
> > Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> > 
> > for the whole series.
> > 
> 
> I have an updated version ready to send out. Will you take this in your
> tree including the 1st patch for pci flags functions? Also, what about
> the powerpc conversion to generic pci flags?

I can take it all in the arm-soc tree, yes. However for anything outside
of arch/arm/{mach,plat}-*, please get an Ack from the respective maintainer
(Russell, Michal, BenH, ...).

	Arnd
