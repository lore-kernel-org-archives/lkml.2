Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab0CPPrt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:47:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab0CPPrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:47:48 -0400
Date: Tue, 16 Mar 2010 16:47:44 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Rupjyoti Sarmah <rsarmah@amcc.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Failure with the 2.6.34-rc1 kernel
In-Reply-To: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com>
Message-ID: <alpine.LRH.2.00.1003161646590.26353@twin.jikos.cz>
References: <AC311A8E81420D4EBC1F26E6479848FE065B7D3D@SDCEXCHANGE01.ad.amcc.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Rupjyoti Sarmah wrote:

> We are seeing issues in booting some of our boards with this new kernel.
> Kernel version upto 2.6.33 works fine on the boards like Canyonlands,
> Katmai, Glacier etc.
> These boards are not booting with kernel later than 2.6.33. Please let
> me know how about fixing these issues ?

You'd need to provide at least dmesg from the working and non-working 
cases.

Also git-bisect between 2.6.33 and 2.6.34-rc1 might help you identify the 
commit that broke your hardware.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

