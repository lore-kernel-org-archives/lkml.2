Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab1IIIGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:06:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55900 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758118Ab1IIIGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:06:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 05/36] Hexagon: Add syscalls
Date: Fri, 09 Sep 2011 10:05:50 +0200
Message-ID: <32094382.BHQ4jXpVFr@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010915.173882729@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010915.173882729@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:NrZeCO8TgpyLfsWdiOcA1K06orj4fFQ5rSVrXxsZtY3
 MbdH+rNR+RJkG5eFvA5DK+rkO3FkrwEfcZeATsb3WIqlTQ6hR3
 Ir1/YnP0pcEo42jwjwNSdk3z5NX7F5Q48xVV+858IdhFOPlQ6u
 mGwWd6KhksAJ2pOn2AaGVlVkfpZJbRTVXwlF+GLkDhXfm5SBkj
 yoB8Vn65YlwWMaQxNjWikX3PMeE2d9rpS+b91p35GQxkPSyp7P
 7If5L6JX3IeBkDjr7AetKLcCfZ5Z7e2x6uTz2ZUKZyF4FG8JCu
 3l2IkopNGpqsMOCEEoVYHYplvVE6YU6CYbmoK4ZzHWjocqv63K
 9HIk2+xhCoMYIXR1v8zg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:08:52 Richard Kuo wrote:
> Removed sys_mmap* and replaced with sys_mmap_pgoff()
> 
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
