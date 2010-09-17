Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab0IQNy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 09:54:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57493 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab0IQNy1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 09:54:27 -0400
Date: Fri, 17 Sep 2010 14:54:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: mahatma@eu.by
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, lrg@slimlogic.co.uk,
        kuninori.morimoto.gx@renesas.com
Subject: Re: platform: Re: #2 (Re: More modaliases + patchtool))
Message-ID: <20100917135410.GB29739@sirena.org.uk>
References: <4C6BE292.3060307@bspu.unibel.by> <201008191020.52861.rusty@rustcorp.com.au> <4C6D26BC.9040805@bspu.unibel.by> <201009111144.34078.rusty@rustcorp.com.au> <4C93702D.4030500@bspu.unibel.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C93702D.4030500@bspu.unibel.by>
X-Cookie: Many suitcases look alike.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 04:42:05PM +0300, Dzianis Kahanovich wrote:
> ...
> Last (14 buses)

Please do try to follow the recommendations in SubmittingPatches,
including those regarding the formatting of your mails and CCing
relevant maintainers and lists.

> Fix lost PLATFORM modalias
> 
> Signed-off-by: Dzianis Kahanovich <mahatma@eu.by>
> 
> --- linux-2.6.36-rc4-git3/sound/soc/sh/fsi.c	2010-09-17 12:30:32.000000000 +0300
> +++ b/sound/soc/sh/fsi.c	2010-09-17 12:39:08.026437283 +0300
> @@ -1250,6 +1250,9 @@ static void __exit fsi_mobile_exit(void)
>  {
>  	platform_driver_unregister(&fsi_driver);
>  }
> +
> +MODULE_DEVICE_TABLE(platform, fsi_id_table);
> +

The normal style for this stuff would be to put the MODULE_DEVICE_TABLE()
next to the actual table.  I will apply a version of your patch with the
addition moved.
