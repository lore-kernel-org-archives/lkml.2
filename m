Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab0LGI1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:27:53 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44013 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab0LGI1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:27:52 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 7 Dec 2010 09:27:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Robin Cook <rcook@wyrms.net>, Clemens Ladisch <clemens@ladisch.de>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
        linux1394-devel <linux1394-devel@lists.sourceforge.net>
Subject: Re: Issue with firewire from 2.6.35.9 to 2.6.36.1
Message-ID: <20101207092735.48b82c40@stein>
In-Reply-To: <1291673087.4022.2.camel@pheuri.wyrms.net>
References: <1291592226.7134.1.camel@pheuri.wyrms.net>
	<1291594279.9196.2.camel@maxim-laptop>
	<20101206082918.6d1ccc41@stein>
	<1291673087.4022.2.camel@pheuri.wyrms.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 06 Robin Cook wrote:
> 07:00.0 FireWire (IEEE 1394) [0c00]: VIA Technologies, Inc. VT6315 Series Firewire Controller [1106:3403]
> 
> The modprobe firewire-ohci quirks=17 worked to get the devices being
> created again.

I wonder which of our options is preferable:
  - Change fw-ohci from MSI blacklisting to whitelisting.  Agere FW643
    rev 07 is the only chip that can be whitelisted.
  - Simply drop MSI support altogether.
-- 
Stefan Richter
-=====-==-=- ==-- --===
http://arcgraph.de/sr/
