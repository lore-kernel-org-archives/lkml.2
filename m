Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759069Ab2I2HfO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2012 03:35:14 -0400
Received: from mail.opencsw.org ([82.220.5.51]:57880 "EHLO mail.opencsw.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758701Ab2I2HfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2012 03:35:11 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2012 03:35:11 EDT
Date: Sat, 29 Sep 2012 09:28:28 +0200
From: Attila Kinali <attila@kinali.ch>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Lauri Hintsala <lauri.hintsala@bluegiga.com>,
        Shawn Guo <shawn.guo@linaro.org>, Chris Ball <cjb@laptop.org>
Subject: Re: [ 074/262] mmc: mxs-mmc: fix deadlock caused by recursion loop
Message-Id: <20120929092828.2249a29f2febb8dbf1e6ae2c@kinali.ch>
In-Reply-To: <20120928183006.777324166@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
	<20120928183006.777324166@linuxfoundation.org>
Organization: NERV
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012 11:50:03 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> From: Greg KH <gregkh@linuxfoundation.org>
> 
> 3.5-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Lauri Hintsala <lauri.hintsala@bluegiga.com>
> 
> commit fc108d24d3a6da63576a460e122fa1df0cbdea20 upstream.
> 
> Release the lock before mmc_signal_sdio_irq is called by
> mxs_mmc_enable_sdio_irq.


Looks ok on this side of the big pond.

			Attila Kinali

-- 
There is no secret ingredient
         -- Po, Kung Fu Panda
