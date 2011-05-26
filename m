Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab1EZMke (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:40:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53218 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757075Ab1EZMkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:40:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 1/6] unicore32: move rtc-puv3.c to drivers/rtc directory
Date: Thu, 26 May 2011 14:40:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, greg@kroah.com,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <b30d22dd12bdba6360749aab88157bb0f2a0303d.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <b30d22dd12bdba6360749aab88157bb0f2a0303d.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261440.14960.arnd@arndb.de>
X-Provags-ID: V02:K0:TQgXBw2bUjmHQ8LuTJ8zD4/sutG5t4d34PTdTKtcSbZ
 If/d798mroQp9g7J5TWly2I4MuJ7YrWUL6QMc4lN7lbhKwX4+9
 mfGuOac/ATMFWxH038xwCwaREwIhqOxFySlG5ua5ZdkKacY264
 m8f+9g39THA8D8G3INWlCQ5Orm1DOl53gGpQCxmZxnB4bDADyv
 MsrK+mqUBPbZC1//38hkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, GuanXuetao wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Acked-by: Arnd Bergmann <arnd@arndb.de>

But next time you move files, please use the '-M' flag to git diff or
git format-patch, to make it easier to review the changes.
