Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab0GWOpP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 10:45:15 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57432 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906Ab0GWOpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 10:45:12 -0400
Date: Fri, 23 Jul 2010 10:32:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Mario 'BitKoenig' Holbe" <Mario.Holbe@TU-Ilmenau.DE>,
        linux-kernel@vger.kernel.org
Subject: Re: b43 wireless driver inhibits access to /dev/hwrng
Message-ID: <20100723143219.GA2426@tuxdriver.com>
References: <20100722225212.GA19361@darkside.kls.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100722225212.GA19361@darkside.kls.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 12:52:12AM +0200, Mario 'BitKoenig' Holbe wrote:
> Hello,
> 
> the b43 wireless driver inhibits access to /dev/hwrng while the wireless
> network interface is down. When the interface is up, /dev/hwrng is
> accessible:

<snip>

> I have no idea whether this issue belongs to the b43 driver or to the
> rng core.

The hwrng driver is provided by the b43 hardware, which is shutdown
when the network interface is down.  I'm not sure how one could expect
this to work.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
