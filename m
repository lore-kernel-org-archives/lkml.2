Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab0JJNvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 09:51:15 -0400
Received: from smtp-out-100.synserver.de ([212.40.180.100]:1057 "HELO
	smtp-out-100.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750887Ab0JJNvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 09:51:14 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Sun, 10 Oct 2010 09:51:13 EDT
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 21635
Date: Sun, 10 Oct 2010 15:44:29 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: REGRESSION 2.6.36: radeon KMS console switch broken
Message-ID: <20101010134429.GA1581@arch.trippelsdorf.de>
References: <20101010123000.GD8256@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101010123000.GD8256@basil.fritz.box>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 10, 2010 at 02:30:00PM +0200, Andi Kleen wrote:
> 
> Hi,
> 
> I see a radeon regression here with 2.6.36-rc7.
> 
> I updated a system from 2.6.35 to 2.6.36-rc7. Now I cannot 
> switch to the text console from the X server anymore; the screen just 
> keeps displaying the X desktop. Eventually when I switch back
> to X things work again. 
> 
> The console switching worked in 2.6.35 
> (I had occasional GPU hangs in .35, but console switch always worked)
> I didn't change the Xserver userland.
> 
> The system has a ATI Technologies Inc RV710/730 running Dual Head.

You're using the radeonhd driver, which is not supported and outdated.
Try to remove  /usr/lib64/xorg/modules/drivers/radeonhd_drv.so and start
X again...
-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
