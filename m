Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab0LMKSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 05:18:35 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:15822 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab0LMKSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 05:18:34 -0500
Date: Mon, 13 Dec 2010 11:18:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Stelian Pop <stelian@popies.net>
Cc: Michael Hanselmann <public@hansmi.ch>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/30] macintosh/ams: don't use flush_scheduled_work()
Message-ID: <20101213111817.1d2087b0@endymion.delvare>
In-Reply-To: <20101213101638.GA2188@calypso>
References: <1292086307-19211-1-git-send-email-tj@kernel.org>
	<1292086307-19211-21-git-send-email-tj@kernel.org>
	<20101211201931.00414518@endymion.delvare>
	<AANLkTinUko5JfbYTOVujXEKqBHfdSXuqAmVcphWZyOrU@mail.gmail.com>
	<20101213101638.GA2188@calypso>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Dec 2010 11:16:38 +0100, Stelian Pop wrote:
> On Sun, Dec 12, 2010 at 02:37:28PM +0100, Michael Hanselmann wrote:
> 
> > On Sat, Dec 11, 2010 at 8:19 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > > On Sat, 11 Dec 2010 17:51:37 +0100, Tejun Heo wrote:
> > >> flush_scheduled_work() is deprecated and scheduled to be removed.
> > >> Directly flush ams_info.worker on detach instead.
> > >
> > > The AMS driver is maintained by Stelian Pop and Michael Hanselmann
> > > according to MAINTAINERS. I am Cc'ing them both.
> > 
> > Change looks good to me, but can't test due to lack of hardware.
> 
> Same here. Looks like this driver can be orphaned...

If so, please submit a patch updating MAINTAINERS. Otherwise you'll
keep getting patches asking for your acknowledgment.

-- 
Jean Delvare
