Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765Ab1IIIUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:20:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52410 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757534Ab1IIIUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:20:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v3 28/36] Hexagon: Add ioremap support
Date: Fri, 09 Sep 2011 10:19:45 +0200
Message-ID: <1341897.KOyUviEHQX@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010917.374485496@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010917.374485496@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:XCfpONU6IMYPEZwu/IqcysZA22eU5nbSZKTKR6DZRdZ
 yHfB7q6OmueiFJlOuhgYIlzRhgpDttMx/lz7HTwkT+at+Z2giM
 XoJ8zsCW49dxgEQUzIsxJ+XDlmI9Or66jv5Ss0EbvLi2r0nhA3
 QO2tOjuVHuLH4rwaS8AnKDXU1yzRGYLea8oVkx4VozuB4egtCh
 ZL5MzVbGNbRk37CNg0g/U8AJue53J2x3YL63eY4bKM4z0w+oqo
 /ikP8lDXtDMv7d81fcHvnkkRPthSNsYCinDb6H59DG6AxPzoAz
 /GWrSrALBOraxf+cX65+vnUAmVveQmSsvPAH+x+uAAtoVgsmXp
 6PPEr47QBr7K+uuSNCmk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:15 Richard Kuo wrote:
> Removed redundant flush_cache_vmap.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
