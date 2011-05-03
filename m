Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751726Ab1ECPBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 11:01:13 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:45745 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ECPBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 11:01:11 -0400
Date: Tue, 3 May 2011 17:01:05 +0200
From: Borislav Petkov <bp@amd64.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, chaoming_li@realsil.com.cn,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
Message-ID: <20110503150105.GC18648@gere.osrc.amd.com>
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 09:47:35AM -0500, Larry Finger wrote:
> This set of patches introduces a driver for the RTL8192SE PCI devices.
> 
> The patches are as follows:
> 
> 01/12: Introduce file def.h
> 02/12: Introduce dynamic management routines dm.c and dm.h
> 03/12: Introduce firmware routines fw.c and fw.h
> 04/12: Introduce hardware control routines hw.c and hw.h
> 05/12: Introduce LED routines led.c and led.h
> 06/12: Introduce PHY routines phy.c and phy.h
> 07/12: Introduce register definition header
> 08/12: Introduce radio control routines
> 09/12: Introduce main routine (sw.c and sw.h)
> 10/12: Introduce tables
> 11/12: Introduce TX/RX routines
> 12/12: Modify Kconfig and Makefiles to build rtl8192se

I think I have such a device in my Thinkpad:

03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)

I could give them a run soon. Do you have them in a tree somewhere I
could pull?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
