Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0GBKS7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 06:18:59 -0400
Received: from hull.simtec.co.uk ([78.105.113.97]:52975 "EHLO
	preston.local.simtec.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754711Ab0GBKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 06:18:56 -0400
X-Greylist: delayed 2386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Jul 2010 06:18:56 EDT
Message-ID: <4C2DB39E.8050600@simtec.co.uk>
Date: Fri, 02 Jul 2010 10:38:38 +0100
From: Ben Dooks <ben@simtec.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Egger <siccegge@cs.fau.de>
CC: Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
       Kukjin Kim <kgene.kim@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Thomas Abraham <thomas.ab@samsung.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 30/33] Removing dead S3C_DEV_ADC
References: <cover.1277911345.git.siccegge@cs.fau.de> <7baaebb4983ce9482e3f83ca42240b864157cb79.1277911346.git.siccegge@cs.fau.de>
In-Reply-To: <7baaebb4983ce9482e3f83ca42240b864157cb79.1277911346.git.siccegge@cs.fau.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/06/10 17:03, Christoph Egger wrote:
> S3C_DEV_ADC doesn't exist in Kconfig, therefore removing all
> references for it from the source code.

This is going to be fixed in the next kernel release, one way
or the other, so please drop this patch

-- 
Ben
