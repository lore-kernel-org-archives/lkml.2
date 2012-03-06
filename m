Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758775Ab2CFIis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 03:38:48 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:32954 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758301Ab2CFIiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 03:38:46 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dmitry.torokhov@gmail.com designates 10.68.191.230 as permitted sender) smtp.mail=dmitry.torokhov@gmail.com; dkim=pass header.i=dmitry.torokhov@gmail.com
Date: Mon, 5 Mar 2012 22:09:47 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, kliu5@marvell.com
Subject: Re: [PATCH 2/3] misc: max8925_onkey: add function to work as wakeup
 source
Message-ID: <20120306060947.GA27389@core.coreip.homeip.net>
References: <20120109002946.GJ13679@sortiz-mobl>
 <1326191080-24524-1-git-send-email-haojian.zhuang@marvell.com>
 <20120220110226.GQ5387@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220110226.GQ5387@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 12:02:26PM +0100, Samuel Ortiz wrote:
> Hi Dmitry
> 
> On Tue, Jan 10, 2012 at 06:24:40PM +0800, Haojian Zhuang wrote:
> > From: Kevin Liu <kliu5@marvell.com>
> Could you please, take this one from the input tree ? All the mfd related bits
> are upstream already.
> Let me know if you prefer that I take it through the MFD tree.
> 

Applied, thanks everyone.

-- 
Dmitry
