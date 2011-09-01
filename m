Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932695Ab1IAXkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 19:40:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35082 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab1IAXkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 19:40:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930257268D10@dbde02.ent.ti.com>
References: <1313903348.25059.3.camel@phoenix> <B85A65D85D7EB246BE421B3FB0FBB5930257268D10@dbde02.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 2 Sep 2011 07:40:12 +0800
Message-ID: <CAF+7xWm3TBBvWbqvsCiP3_yLykZxW0sW1Q454KJGVLDmkr8Rbw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mach-davinci: Select PHYLIB for ARCH_DAVINCI_DM644x
To: "Nori, Sekhar" <nsekhar@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/2 Nori, Sekhar <nsekhar@ti.com>:
> Hi Axel,
>
> On Sun, Aug 21, 2011 at 10:39:08, Axel Lin wrote:
>> We call phy_register_fixup_for_uid in davinci_evm_init, thus we need
>> select PHYLIB to fix below build error: (with "make davinci_all_defconfig")
>
> This shouldn't happen with davinci_all_defconfig as it
> selects PHYLIB (this doesn't undermine the need for a fix).

I remember that I got the build error with davinci_all_defconfig, but
the build seems ok now with linux-next ( next-20110831 ).

Regards,
Axel
