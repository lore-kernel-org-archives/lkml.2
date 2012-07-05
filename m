Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2GEKa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:30:26 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48878 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab2GEKaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:30:20 -0400
Date: Thu, 5 Jul 2012 12:29:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8 v3] i2c: i801: enable irq for i801 smbus 
 transactions
Message-ID: <20120705122953.3e458a30@endymion.delvare>
In-Reply-To: <20120705101015.1e3a3afc@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-8-git-send-email-djkurtz@chromium.org>
	<20120704221600.416d4475@endymion.delvare>
	<CAGS+omAwkwd17MVe3uWoPNCL3y0BvKDvbFGWwjhJ5CpTqncsXA@mail.gmail.com>
	<20120705101015.1e3a3afc@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jul 2012 10:10:15 +0200, Jean Delvare wrote:
> On Thu, 5 Jul 2012 12:31:11 +0800, Daniel Kurtz wrote:
> > On Thu, Jul 5, 2012 at 4:16 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > > Implementing 1* has the drawback of limiting interrupt support to ICH5
> > > and later chips, but I suspect it is the easiest and safest way, so I
> > > have no objection if you want to do that.
> > 
> > Let's do this first, and then refactor later to add support for
> > pre-ICH5 parts, if needed.
> 
> OK, fine with me. The only downside is that it excludes my
> heavily-shared IRQ test machine, so testing that the shared IRQ case is
> properly covered will be a little harder.

Actually, no problem there: I can reproduce the issue just fine on my
ICH5 system, which shares an IRQ between the sound chip and the SMBus
controller. So I can use that system to test the updated code too.

-- 
Jean Delvare
