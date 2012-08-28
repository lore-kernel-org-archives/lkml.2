Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2H1JAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 05:00:32 -0400
Received: from h1346787.stratoserver.net ([85.214.49.182]:56116 "EHLO
	h1346787.stratoserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2H1JAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 05:00:31 -0400
X-Greylist: delayed 934 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Aug 2012 05:00:31 EDT
From: Carsten Wolff <carsten@wolffcarsten.de>
To: Alexander Bergmann <alex@linlab.net>
Subject: Re: [PATCH 1/1] tcp: Wrong timeout for SYN segments
Date: Tue, 28 Aug 2012 10:44:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.32-5-686; KDE/4.4.5; i686; ; )
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        hkjerry.chu@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1345724123.5904.756.camel@edumazet-glaptop> <20120824.134231.41073001349178209.davem@davemloft.net> <20120825084819.GD430@linlab.net>
In-Reply-To: <20120825084819.GD430@linlab.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201208281044.40057.carsten@wolffcarsten.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Saturday 25 August 2012, Alexander Bergmann wrote:
> This patch increases the value of TCP_SYN_RETRIES to the value of 6,
> providing a retransmission window of 63secs.
> 
> The comments for SYN and SYNACK retries have also been updated to
> describe the current settings.

wouldn't it be nice, if the description of the corresponding sysctls in 
Documentation/networking/ip-sysctl.txt could be updated too?

Cheers
Carsten
