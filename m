Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab1IIIPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:15:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61651 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758539Ab1IIIPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:15:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 19/36] Hexagon: Add ptrace support
Date: Fri, 09 Sep 2011 10:15:22 +0200
Message-ID: <6788879.2Pf4OtZvAN@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.525482401@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.525482401@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:nHvylQkrMXb6twBYlRk+W8/ea6GHb/69y5AHD9Tf2sB
 rXmLl9OoMp7vaa4sLaib6MlnMFbrcsb3S0HbkDDPx+yaYn+aPZ
 bjezVzNvsGlmlKjCzD7zqg/Y4udCARf+SUAYOuXjX2CAKyhrx7
 izmrUc5gUcJ3GejKhaS/6tSl5ifyYM3rYyLzCyCxhaAHrb8HgZ
 wR+v5eSdwW/QK0iz0DOyhPOKa7/TRUhBe/fcgrCh0UEGsjjWvM
 ROSu8UECW1fB0/yU7RB3mdWAF9jjpcGBE/HHHCZvUn03YKjKEb
 gmRYbBMydlqnWMXD5+HhFc0ZaHHBAutgs5E3nZDHKmII/G3v+T
 9vzwXKtVl45k/KIfu5KI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:06 Richard Kuo wrote:
> Will look at the more generic ptrace support in the future.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Note that this absolutely has to be completed before the code is merged upstream,
because it is relevant to the ABI.

	Arnd
