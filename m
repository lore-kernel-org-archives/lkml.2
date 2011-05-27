Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738Ab1E0Dl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:41:29 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:41845 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758640Ab1E0DlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:41:25 -0400
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Arnd Bergmann'" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <greg@kroah.com>, <netdev@vger.kernel.org>
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <556924396ee34f4af94a2f03767973f1cec35e22.1306408804.git.gxt@mprc.pku.edu.cn> <201105261443.06896.arnd@arndb.de>
In-Reply-To: <201105261443.06896.arnd@arndb.de>
Subject: RE: [PATCH 2/6] unicore32: add pkunity-v3 mac/net driver (umal)
Date: Fri, 27 May 2011 11:08:57 +0800
Message-ID: <005901cc1c1b$6b80ce40$42826ac0$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIcsKU1gucno1VE3ekXHpcmNwpJlQJbGgG/AZaWcWKT30bDIA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, May 26, 2011 8:43 PM
> To: GuanXuetao
> Cc: linux-kernel@vger.kernel.org; linux-arch@vger.kernel.org; greg@kroah.com; netdev@vger.kernel.org
> Subject: Re: [PATCH 2/6] unicore32: add pkunity-v3 mac/net driver (umal)
> 
> On Thursday 26 May 2011, GuanXuetao wrote:
> > From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> >
> > Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> No objections to this driver, just remember that network drivers should
> go through the netdev tree, and if it wasn't in there before the merge
> window, you missed your chance for this time.
Yes.
I hope someone could help me review the network driver.
Perhaps it's  late for adding this driver during this merge window time.

Regards.
Guan Xuetao

