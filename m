Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758731Ab1E0DEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:04:52 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:59819 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753085Ab1E0DEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:04:49 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        <rtc-linux@googlegroups.com>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <b30d22dd12bdba6360749aab88157bb0f2a0303d.1306408804.git.gxt@mprc.pku.edu.cn> <201105261440.14960.arnd@arndb.de>
In-Reply-To: <201105261440.14960.arnd@arndb.de>
Subject: RE: [PATCH 1/6] unicore32: move rtc-puv3.c to drivers/rtc directory
Date: Fri, 27 May 2011 11:04:03 +0800
Message-ID: <005801cc1c1a$bea0fa10$3be2ee30$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIcsKU1gucno1VE3ekXHpcmNwpJlQHtAVp6AXFx/KmT499WMA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, May 26, 2011 8:40 PM
> To: GuanXuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com; Alessandro Zummo; rtc-linux@googlegroups.com
> Subject: Re: [PATCH 1/6] unicore32: move rtc-puv3.c to drivers/rtc directory
> 
> On Thursday 26 May 2011, GuanXuetao wrote:
> > From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> But next time you move files, please use the '-M' flag to git diff or
> git format-patch, to make it easier to review the changes.

'-M' flag is so smart.
Thanks.

Guan Xuetao

