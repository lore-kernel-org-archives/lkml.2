Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab0GIHxM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 03:53:12 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:50232
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751411Ab0GIHxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 03:53:09 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dN936eMzz1202hzzz32i2a8h62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0L5A5UC-02-7EF-02
X-M-MSG: 
Date: Fri, 9 Jul 2010 09:51:49 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@lst.de>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH 11/18] oprofile: make event buffer nonseekable
Message-ID: <20100709075149.GA21909@erda.amd.com>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de>
 <1278538820-1392-12-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1278538820-1392-12-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.07.10 17:40:13, Arnd Bergmann wrote:
> The event buffer cannot deal with seeks, so
> we should forbid that outright.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Robert Richter <robert.richter@amd.com>
> Cc: oprofile-list@lists.sf.net

Acked-by: Robert Richter <robert.richter@amd.com>

Thanks Arnd,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

