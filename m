Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932327Ab1IIIQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 04:16:43 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:65508 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758549Ab1IIIQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 04:16:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Richard Kuo <rkuo@codeaurora.org>
Cc: linux-arch@vger.kernel.org, linux-hexagon@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linas Vepstas <linas@codeaurora.org>
Subject: Re: [patch v3 21/36] Hexagon: Add SMP support
Date: Fri, 09 Sep 2011 10:16:21 +0200
Message-ID: <15669045.OftK0xyS1C@wuerfel>
User-Agent: KMail/4.7.0  (Linux/3.0.0-rc1nosema+; KDE/4.7.0; x86_64; ; )
In-Reply-To: <20110909010916.709728186@codeaurora.org>
References: <20110909010847.294039464@codeaurora.org> <20110909010916.709728186@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:QNfLvYUSPNsuziATe3SL5iQDK+9w3AF51UVK1rLFgmy
 +KMHJJYguBa/jq6ZyMk1s8LcNYGzAMAhv0UcAaQdNAO1KLJLQ7
 UNSVEBOEsYxOQRFz/z+4MY/FTrSYnzh30WxxuAxWHAAjJCTet+
 FKJTQBamtTowdznPZDZ5NlEMp1aWlDZRqljfzaAB9jW7hhT3CC
 asBKjoseAUssiYC+J6tQGssONPIITLUFgAXlCoSuACR5lOpsI+
 t4FUxk9pTF3ssiTUwoFJNTiYV+gpxD1N8DtZI4DnlTR3HwkPbR
 xtO7XBdHG4DUNcHGAhaK65x1tHAYc+nmSixBtTzopbRmGrx2gl
 IVYX17oGgyzavZ2APm58=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 September 2011 20:09:08 Richard Kuo wrote:
> Changed smp.c to use generic IPI handler functions.
> 
> Signed-off-by: Richard Kuo <rkuo@codeaurora.org>
> Signed-off-by: Linas Vepstas <linas@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
