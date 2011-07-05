Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab1GELq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:46:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56450 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755659Ab1GELqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:46:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 5/8] mm: MIGRATE_CMA isolation functions added
Date: Tue, 5 Jul 2011 13:45:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <1309851710-3828-6-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309851710-3828-6-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051345.14502.arnd@arndb.de>
X-Provags-ID: V02:K0:SjIpnqiTcEdwQ3RndFtj1Ny+A+O3JOE83if0ESlT0Qb
 I3SCxri1gFM9abUGPfBK2bz5rum9DhyRU2qquTl4FYy0lveJcj
 JzGFZQK5gopZOg0dXPJ7VD1yM3UyrXps+4AcApQ9/YcrsWpQPi
 ExY5LQQBq2s6uMIUkeoqVqdw6mo0RB0RfZjALHQuvKgX6sx2af
 Mw5FT4JWP6O3DssdnBRKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Marek Szyprowski wrote:
> From: Michal Nazarewicz <m.nazarewicz@samsung.com>
> 
> This commit changes various functions that change pages and
> pageblocks migrate type between MIGRATE_ISOLATE and
> MIGRATE_MOVABLE in such a way as to allow to work with
> MIGRATE_CMA migrate type.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> CC: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Arnd Bergmann <arnd@arndb.de>
