Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676Ab1L0RKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 12:10:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57682 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754381Ab1L0RKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 12:10:36 -0500
Date: Tue, 27 Dec 2011 17:10:33 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, cocci@diku.dk,
        linux-kernel@vger.kernel.org, mmarek@suse.cz
Subject: Re: [PATCH 1/2] scripts/coccinelle: semantic patches related to
 devm_ functions
Message-ID: <20111227171032.GA22729@sirena.org.uk>
References: <1325004092-28162-1-git-send-email-julia.lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325004092-28162-1-git-send-email-julia.lawall@lip6.fr>
X-Cookie: Gloffing is a state of mine.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 05:41:31PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>

Something went wrong here?

> devm_ functions allocate memory that is to remain allocated until the
> device is detached.  This patch checks for opportunities for using the
> function devm_request_and_ioremap.

Note that devm_request_and_ioremap() is scheduled for merge in 3.3 so
patches based on this should probably wait until after that has been
merged.
