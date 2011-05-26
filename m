Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556Ab1EZMnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 08:43:18 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55510 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755821Ab1EZMnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 08:43:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: GuanXuetao <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCH 2/6] unicore32: add pkunity-v3 mac/net driver (umal)
Date: Thu, 26 May 2011 14:43:06 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-28-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, greg@kroah.com,
        netdev@vger.kernel.org
References: <cover.1306408804.git.gxt@mprc.pku.edu.cn> <556924396ee34f4af94a2f03767973f1cec35e22.1306408804.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <556924396ee34f4af94a2f03767973f1cec35e22.1306408804.git.gxt@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105261443.06896.arnd@arndb.de>
X-Provags-ID: V02:K0:Z9Mj7lxFixM+EwIrDnU2g9XlER7hMMeSIQNL0zTRUe9
 knWDvKFYbiknSfnSJ1m1npPGHRtJmyANpVw5jEJpKcFZEwLCsF
 uYFzYUx8VjJI7g/ygKseBUozT6ClvGaMIQRSvlH6Z39ih/GGd/
 mWwlfuKEP+0LLoMw3kAg11dXjZUdlFv2ULCZWtE2ZVwEsEKyfy
 yZn0PwyJ8J5SV5d2ATU3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 May 2011, GuanXuetao wrote:
> From: Guan Xuetao <gxt@mprc.pku.edu.cn>
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

No objections to this driver, just remember that network drivers should
go through the netdev tree, and if it wasn't in there before the merge
window, you missed your chance for this time.
