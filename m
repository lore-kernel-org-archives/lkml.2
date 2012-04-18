Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752199Ab2DRIhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:37:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62483 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2DRIhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:37:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v2 7/8] ARM: LPC32xx: DTS files for device tree conversion
Date: Wed, 18 Apr 2012 08:10:02 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Roland Stigge <stigge@antcom.de>, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        axel.lin@gmail.com, broonie@opensource.wolfsonmicro.com,
        marek.vasut@gmail.com, devel@driverdev.osuosl.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
References: <1334682507-15055-1-git-send-email-stigge@antcom.de> <1334682507-15055-8-git-send-email-stigge@antcom.de> <20120418054615.GB17506@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20120418054615.GB17506@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204180810.02561.arnd@arndb.de>
X-Provags-ID: V02:K0:9vBnyTLqZk2G8yZYZgHVmkHiOdaufH7zsd6FZM4rfRa
 6/dN5T7AyOdP5p6ug8dLF4KmIYivAPaqXQj/PV3zt2HKqK/W0R
 sBT5h8fXiVuhcoRAH8HgIvKYsE2oHBOCzk0lqA5ZgCLYt2XDgc
 O2XGITPmpdWqa8pBMGPCLdN7UXr6UM6VnHBALqA6EFJLyY4LyY
 tzIMneRpNHQO0XhSLT/0iqsZDjA6By8sB8dx+uNi07C3mmLFM3
 xnxAYbdO8C2G+B+sLhkEY7GO+zj1Qf3nHrRl0seknqPCu0uwz3
 EkX7mv7Fu851dqZZqEa3JLUzNORskpU+Tb6GiLJNZZ2WP01K9f
 x5lvIx5HLuJ/fJWcp1MM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 April 2012, Thierry Reding wrote:
> [...]
> > +                     /*
> > +                      * MIC Interrupt controller includes:
> > +                      *   MIC @40008000
> > +                      *   SIC1 @4000C000
> > +                      *   SIC2 @40010000
> > +                      */
> > +                     mic: interrupt-controller@40008000 {
> > +                             compatible = "nxp,lpc32xx-mic";
> > +                             interrupt-controller;
> > +                             interrupt-parent;
> 
> I think in this case you can leave this out. At least there doesn't seem to
> be any other such usage in the tree.
> 

It's actually a bug and we're removing all empty "interrupt-parent"
properties from the dts files now because they cause problems. Please don't
introduce new ones.

	Arnd

