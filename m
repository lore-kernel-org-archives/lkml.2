Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab1IIISa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:18:30 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62486 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab1IIIS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:18:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 24/36] Hexagon: Provide basic implementation and/or stubs for I/O routines.
Date: Fri, 09 Sep 2011 10:18:09 +0200
Message-ID: <1604210.HF5P4V98ih@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.993872033@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.993872033@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:X3MCmjmMX+a3uc3WKc4sRjLn7wW+zNTpjGxFeHOIPoA
 VdxdJ08tCOJyP2EJ09lOuhRMbiCp9lmCh+OOMCXhXpiZjpA8Mx
 2MUCbOAacooMGoSmS7FR711rcCQ2w21PcsPHb0AWQw87+zWWXY
 AJMT33jD7C8OFXDawyQTYf1sHk95MwocHkBf4FRL6SvMov6unX
 XL6uahR5pEB5cnBbDO0IzAI3wTqKMglXkgUepX5BOCaPq1hQqy
 ce7te3QJ4dlh9QPcKvMIV+M8/BG9PNKQp2MaFIrwX392axmnRa
 Y1aSqqCJ2lTPwh0k2MZn2owThoZnEQnRV5lJpsdJwZFwtWt4/B
 ytukaZfk2Xqszgff5EC8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:11 Richard Kuo wrote:
> Filled in the ins/outs; leaving them in for now.
> 
> Change _IO_BASE and IO_SPACE_LIMIT for safety.
> 
> I have compiled this with sparse and it builds; I've also picked over
> various files related to the HAS_IOPORT_MAP from arm-soc.git and
> tried them out, and they work, so I guess we'll just wait until
> they're merged.
> 
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
