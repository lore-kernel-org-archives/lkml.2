Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab1H0TDC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 15:03:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65332 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1H0TC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 15:02:58 -0400
Subject: Re: [PATCH] mmc: tmio: eliminate unused variable 'mmc' warning
From: Ian Molton <ian@mnementh.co.uk>
Reply-To: ian@mnementh.co.uk
To: Chris Ball <cjb@laptop.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org
Date: Sat, 27 Aug 2011 20:02:51 +0100
In-Reply-To: <m2liva7ize.fsf@bob.laptop.org>
References: <1312354138.14329.1.camel@phoenix>
	 <Pine.LNX.4.64.1108030924440.28502@axis700.grange>
	 <m2liva7ize.fsf@bob.laptop.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.5-
Content-Transfer-Encoding: 7bit
Message-ID: <1314471775.2138.28.camel@drake>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-03 at 08:55 -0400, Chris Ball wrote:
> > Good for 3.1, do we also push such "harmless" compiler warning fixes
> to 
> > stable?
> >
> > Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> 
> Pushed for 3.1, thanks.  I don't think this is appropriate for stable.

Why on earth not? its obviously correct...

