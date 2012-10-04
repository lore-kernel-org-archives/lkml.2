Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965571Ab2JDIfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:35:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60194 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964998Ab2JDIfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:35:05 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 01/17] ARM: shmobile: fix memory size for kota2_defconfig
Date: Thu, 4 Oct 2012 08:34:54 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
References: <1349195816-2225-1-git-send-email-arnd@arndb.de> <1349195816-2225-2-git-send-email-arnd@arndb.de> <20121003003759.GD31207@verge.net.au>
In-Reply-To: <20121003003759.GD31207@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201210040834.55096.arnd@arndb.de>
X-Provags-ID: V02:K0:yNNPgitIJrQJBY334CBf0IPEN9v3wpRLqSKmYzc8VTC
 KM3yPP9r9orn4W6+ecwrQQtz/oFuvvfohQ2NBBT8whfS0Bqjkx
 sRCVpsJhL1cvlX4yWB8xl9JXyp9ZWXFtcdh/EAm+2hcrkNHSkq
 +3uEhS6VP8BSQzP1g2R7D6MtuLDUfvH/79y7RfRwIoe/WEIMid
 sNhaf0xjS3ePm9AclbfPQu78dIA780WRrYO0h0TGHiuWJIjax5
 WyJxVv0pRRSeVk+s3/hEdmxUDgqjN7dUpAHIsoTkdVrl9gLvRV
 oeeo2sReWrX6TzrabJd0iEbZYhASUB1Bp2TFhfAK/Em9a1ADOJ
 rvvcrk7wLvrRWckGqLfw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 October 2012, Simon Horman wrote:
> I looked through my fines and found a config that I believe
> worked with a derivative of 2.6.35.7.
> 
> It has CONFIG_MEMORY_SIZE=0x1e800000.
> 
> So what I suspect has happened is that an extra zero has crept into
> arch/arm/configs/kota2_defconfig and the intended value is:
> 
> CONFIG_MEMORY_SIZE=0x1e000000
> 
> Unfortunately I do not have access to a board to test this,
> nor am I aware of anyone who does.

Ok, I'll drop this patch for now then, so we keep the warning around
to remind us of the problem.

	Arnd
