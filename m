Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab1DMWdq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 18:33:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60014 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab1DMWdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 18:33:45 -0400
Date: Thu, 14 Apr 2011 07:33:39 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [alsa-devel] [PATCH 1/7] ASoC: neo1973_wm8753: Remove scenario
 management code.
In-reply-to: <4DA4AFE6.8050007@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, "'Jassi Brar'" <jassi.brar@samsung.com>
Message-id: <01bc01cbfa2a$d82588a0$887099e0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acv5TIvkPUZs+qPlT8eu31RBPJyo0gA3Lc3g
References: <1299481500-5481-1-git-send-email-lars@metafoo.de>
 <1299495878.3377.17.camel@odin>
 <20110307122520.GI13471@opensource.wolfsonmicro.com>
 <4DA4AFE6.8050007@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> On 03/07/2011 01:25 PM, Mark Brown wrote:
> > On Mon, Mar 07, 2011 at 11:04:38AM +0000, Liam Girdwood wrote:
> >
> >> Just had a quick look. All
> >
> >> Acked-by: Liam Girdwood <lrg@ti.com>
> >
> > Applied 1-6 - I'll wait for Kukjin to check patch 7 just in case he
> > wants it to go via his tree, there's no compile time dependency.
> 
Oops, maybe I missed. Because he didn't send to me, Linux ARM Kernel mailing
list or Linux Samsung SoC mailing list at that time.

> Thanks.
> 
> So far patch 7 (adding the dfbmcs320 platform device to gta02 mach file)
> hasn't
> been applied. Should I resent it, or do you still have it?
> 
Anyway, I checked Mark's applying just now. It's ok to me :)

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

