Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab1HYL2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:28:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59098 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1HYL2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:28:21 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v3 2/4] msm_serial: Add devicetree support
Date: Thu, 25 Aug 2011 13:28:05 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Alan Cox <alan@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-serial@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
References: <1313688345-17699-1-git-send-email-davidb@codeaurora.org> <1313688345-17699-3-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1313688345-17699-3-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201108251328.05689.arnd@arndb.de>
X-Provags-ID: V02:K0:wSoguk/fcmQMguQeX0FohhpNGaHeFJU2gG/FPJK8B4c
 6VXui8xuqVAyJDWC74atRvD+OXCZ+rrRAYyAWMN3BjkmlsqC1z
 YaZw3D4l9oaw80HaWKXJ2K5JPHVdDLReouXcT0aNiyFZ5yg8tf
 0liWODcESJh8flm38dwwVR4Y4++Mu/CAHnc5PkOnI5O8jMzEz1
 MSrZ+4Ep1nUgRHbVjTPjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 18 August 2011, David Brown wrote:
> Add devicetree support to the msm_serial driver.  Clocks are still
> queried by direct name from the driver until device tree clock support
> is implemented.
> 
> Signed-off-by: David Brown <davidb@codeaurora.org>

Acked-by: Arnd Bergmann <arnd@arndb.de>
