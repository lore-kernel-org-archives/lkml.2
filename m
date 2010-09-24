Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731Ab0IXH5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:57:44 -0400
Received: from static.88-198-202-190.clients.your-server.de ([88.198.202.190]:45192
	"EHLO kleinhenz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab0IXH5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:57:43 -0400
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 03:57:42 EDT
Date: Fri, 24 Sep 2010 09:34:53 +0200
From: Simon Richter <Simon.Richter@hogyros.de>
To: Darius Augulis <augulis.darius@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, kgene.kim@samsung.com,
        paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
Subject: Re: [RESEND PATCH] serial: samsung: fix device name
Message-ID: <20100924073453.GA3840@richter>
References: <20100923190212.18863.25678.stgit@darius-desktop>
 <4C9BE577.4050504@fluff.org>
 <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=S8v19iT1DC=6Nh9BEgRvKzyzKTKoJmS0Bw1Fb@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Sep 24, 2010 at 09:57:19AM +0300, Darius Augulis wrote:

> It does - now devices are named /dev/s3c2410_serial, and patch changes
> its name to /dev/ttySAC

I wonder if it'd make sense to name them ttyS[0-9]. I've never
understood why the platform standard fixed serial ports on any device
should have a different name.

   Simon
