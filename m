Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab2EMKxj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 06:53:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54734 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2EMKxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 06:53:37 -0400
Date: Sun, 13 May 2012 11:53:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, dmitry.torokhov@gmail.com,
        peter.ujfalusi@ti.com, broonie@opensource.wolfsonicro.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TWL6040: fix build error
Message-ID: <20120513105331.GC706@sirena.org.uk>
References: <1336675473-24774-1-git-send-email-levinsasha928@gmail.com>
 <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP=VYLqwAO8x4aWw7_pH1LH_SPO9Td2ec9oOmKPL-_5LOEQw3g@mail.gmail.com>
X-Cookie: I'm not proud.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 06:49:16PM -0400, Paul Gortmaker wrote:
> On Thu, May 10, 2012 at 2:44 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
> > Fixes build error due to missing of_property_read_u32.

> Yes, I saw the same on x86-64 allyesconfig -- which means that in addition to
> this missing header, it needs to have a Kconfig dependency that limits
> it to just being enabled on the platforms where it physically is possible to
> have the hardware.  I'm guessing limiting to ARM would be a good start?

Half the idea is to get better test coverage and help people who want to
do things like build test API updates - the more systems the driver can
be built on the better from that point of view.
