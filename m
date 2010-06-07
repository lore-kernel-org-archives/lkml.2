Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab0FGQR2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 12:17:28 -0400
Received: from zinan.dashjr.org ([173.242.112.54]:51790 "EHLO zinan.dashjr.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751591Ab0FGQR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 12:17:27 -0400
From: "Luke-Jr" <luke@dashjr.org>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: Re: OMAP video compile error; regression from 2.6.33-rc4 onward (including current master)
Date: Mon, 7 Jun 2010 11:17:15 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32-gentoo; KDE/4.3.5; x86_64; ; )
Cc: "slapin@ossfans.org" <slapin@ossfans.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <201006061652.39248.luke@dashjr.org> <1275896854.2549.14.camel@tubuntu.research.nokia.com>
In-Reply-To: <1275896854.2549.14.camel@tubuntu.research.nokia.com>
X-PGP-Key-Fingerprint: CE5A D56A 36CC 69FA E7D2 3558 665F C11D D53E 9583
X-PGP-Key-ID: 665FC11DD53E9583
X-PGP-Keyserver: x-hkp://subkeys.pgp.bet
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006071117.22645.luke@dashjr.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 June 2010 02:47:34 am Tomi Valkeinen wrote:
> I don't have any device that uses RFBI so I can't test it, but how about
> this patch:

Unfortunately, I can't test it either since N8x0 has no mainline support for 
video output, nor can until CBus is merged. :(
