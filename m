Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1EDRBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 13:01:38 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:40126 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1EDRBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 13:01:37 -0400
Date: Wed, 4 May 2011 19:01:31 +0200
From: Borislav Petkov <bp@amd64.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Borislav Petkov <bp@amd64.org>, John W Linville <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        chaoming_li@realsil.com.cn,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 00/12] rtlwifi: rtl8192se: Merge new driver
Message-ID: <20110504170131.GA12126@gere.osrc.amd.com>
References: <4dc01587.AfSJXmRO80K/pl3f%Larry.Finger@lwfinger.net>
 <20110503150105.GC18648@gere.osrc.amd.com>
 <4DC05F9C.2070802@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC05F9C.2070802@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 03, 2011 at 03:03:40PM -0500, Larry Finger wrote:
> On 05/03/2011 10:01 AM, Borislav Petkov wrote:
> >I think I have such a device in my Thinkpad:
> >
> >03:00.0 Network controller [0280]: Realtek Semiconductor Co., Ltd. RTL8191SEvB Wireless LAN Controller [10ec:8172] (rev 10)
> >
> >I could give them a run soon. Do you have them in a tree somewhere I
> >could pull?
> 
> Your device is claimed by the new driver.
> 
> You can get the code from
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/lwfinger/rtl8192se.git
> 
> This tree is based on Linville's wireless-testing tree with these 12
> patches applied.

Ok, pulled, merged with mainline, built and currently using it to read
mail over imap! I wish everything else in Linux worked that way :).

Good job, thanks!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
