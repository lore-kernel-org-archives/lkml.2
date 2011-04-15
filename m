Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1DOG7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 02:59:17 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:40087 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368Ab1DOG7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 02:59:16 -0400
Date: Fri, 15 Apr 2011 08:59:14 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Martin Teufel <teufel@informatik.uni-frankfurt.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: bug in radeon driver module of linux 2.6.38 (since 2.6.35)
Message-ID: <20110415065914.GA1652@x4.trippels.de>
References: <20110414215118.GA30387@hekate.rbi.informatik.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110414215118.GA30387@hekate.rbi.informatik.uni-frankfurt.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.14 at 23:51 +0200, Martin Teufel wrote:
> 
> I encountered a bug in the radeon driver module of 2.6.37 which still
> exists in 2.6.38.
> I have a mainboard called M2A-VM which has VGA, DVI and display port as
> graphic output ports. When I boot Debian GNU/Linux with Linux 2.6.37 or
> 2.6.38 I get every 10 seconds:
> 
> radeon 0000:01:05.0: HDMI-A-1: EDID block 0 invalid.
> [drm:radeon_dvi_detect] *ERROR* HDMI-A-1: probed a monitor but no|invalid EDID
> 
> This error message is spamming to tty1 (and because of my configuration
> to ttyS0 too). With radeon.modeset=0 set, I get rid of this messages by
> disabling KMS for this driver.

drm_kms_helper.poll=0 is what I use locally here. Maybe it helps in your
case, too.

-- 
Markus
