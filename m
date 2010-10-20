Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab0JTS73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 14:59:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52232 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753044Ab0JTS71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 14:59:27 -0400
Date: Wed, 20 Oct 2010 19:59:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Mike Frysinger <vapier@gentoo.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        device-drivers-devel@blackfin.uclinux.org,
        Michael Hennerich <michael.hennerich@analog.com>
Subject: Re: [PATCH] i2c: add irq_flags to board info
Message-ID: <20101020185924.GA7721@sirena.org.uk>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org> <20101018103610.77b7e605@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101018103610.77b7e605@endymion.delvare>
X-Cookie: I am two with nature.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:36:10AM +0200, Jean Delvare wrote:
> On Sun, 17 Oct 2010 19:43:39 -0400, Mike Frysinger wrote:

> > This allows us to avoid having to add dedicated platform init code just
> > to call set_irq_type()

> Do you have examples of this? Can we see a preview of the amount of
> cleanups this patch would allow?

wm831x has platform data for this.  It doesn't actually call
set_irq_type(), it parses the platform data before calling
request_threaded_irq(), but the principle is the same.
