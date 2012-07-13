Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934364Ab2GMBtq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 21:49:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65417 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082Ab2GMBto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 21:49:44 -0400
Date: Thu, 12 Jul 2012 18:49:39 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rolf Offermanns <rolf.offermanns@gmx.net>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 22/68] ath9k_hw: avoid possible infinite loop in
 ar9003_get_pll_sqsum_dvc
Message-ID: <20120713014939.GA6732@kroah.com>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
 <20120712175037.411246837@linuxfoundation.org>
 <20120713013835.GA3121@herton-Z68MA-D2H-B3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120713013835.GA3121@herton-Z68MA-D2H-B3>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 10:38:35PM -0300, Herton Ronaldo Krzesinski wrote:
> On Thu, Jul 12, 2012 at 04:01:56PM -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> > 
> > commit f18e3c6b67f448ec47b3a5b242789bd3d5644879 upstream.
> > 
> > "ath9k: Fix softlockup in AR9485" with commit id
> > 64bc1239c790e051ff677e023435d770d2ffa174 fixed the reported
> > issue, yet its better to avoid the possible infinite loop
> > in ar9003_get_pll_sqsum_dvc by having a timeout as suggested
> > by ath9k maintainers.
> > http://www.spinics.net/lists/linux-wireless/msg92126.html.
> > Based on my testing PLL's locking measurement is done in
> > ~200us (2 iterations).
> 
> Missing the rest of the patch here.

Yeah, quilt went crazy and messed things up, the originals are fine,
but something went really wrong when the mbox was created, sorry.  A
number of different patches didn't go through properly.

greg k-h
