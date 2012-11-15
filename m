Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768387Ab2KOQNK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 11:13:10 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:58445 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1768347Ab2KOQNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 11:13:08 -0500
Date: Thu, 15 Nov 2012 08:13:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/Sandy Bridge: reserve pages when integrated
 graphics is present
Message-ID: <20121115081322.74004a52@jbarnes-desktop>
In-Reply-To: <20121115124711.GA31504@khazad-dum.debian.net>
References: <1352925811-2598-1-git-send-email-jbarnes@virtuousgeek.org>
	<20121115124711.GA31504@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012 10:47:11 -0200
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Wed, 14 Nov 2012, Jesse Barnes wrote:
> > +		unsigned long bad_ranges[] = {
> > +			0x20050000,
> > +			0x20110000,
> > +			0x20130000,
> > +			0x20138000,
> > +			0x40004000,
> 
> Yikes.  Can this be fixed through a microcode update?  The kernel would
> still need the workaround anyway, but at least you would be able to be quite
> heavy-handed on it, and users could be warned of a better fix...

No, this affects the logic on the GPU side, so there's no microcode way
to fix it.

-- 
Jesse Barnes, Intel Open Source Technology Center
