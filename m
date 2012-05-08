Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2EHKA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 06:00:26 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:52699
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752521Ab2EHKAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 06:00:25 -0400
Message-ID: <4FA8EEB3.2080902@compulab.co.il>
Date: Tue, 08 May 2012 13:00:19 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.3) Gecko/20120409 Thunderbird/10.0.3
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Jonathan Cameron <jic23@cam.ac.uk>,
        Marek Vasut <marek.vasut@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mach-pxa: Use REGULATOR_SUPPLY macro
References: <1336465510.11954.1.camel@phoenix>
In-Reply-To: <1336465510.11954.1.camel@phoenix>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/12 11:25, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

[...]

>  arch/arm/mach-pxa/cm-x300.c   |    4 +---
>  arch/arm/mach-pxa/em-x270.c   |    5 +----

Acked-by: Igor Grinberg <grinberg@compulab.co.il>

[...]


-- 
Regards,
Igor.
