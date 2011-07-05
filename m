Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932230Ab1GELvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:51:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:54080 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab1GELvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:51:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 8/8] ARM: S5PV210: example of CMA private area for FIMC device on Goni board
Date: Tue, 5 Jul 2011 13:51:26 +0200
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
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <1309851710-3828-9-git-send-email-m.szyprowski@samsung.com>
In-Reply-To: <1309851710-3828-9-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051351.26634.arnd@arndb.de>
X-Provags-ID: V02:K0:JkgXMf+y8Ndr5G3a8AJqUPoVK+9pwEFfnhWoznpjcHb
 Kg70yQRlFVMmVRPgk8pvkkSVP6nnkDKpBtRfjg95dz9q6Xx0T5
 4UVmQ9pul/OAb8XBbt9tLhyn3VFUmWpS+Wqmy+0SENVyLo001F
 MqXVFUBW9sm/HKlnVxPWWTfBMqKgCNK+OSvA9bWbsSF9y3CGHu
 1ac9KqzV/O2W5HvrBJG2A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Marek Szyprowski wrote:
> 
> This patch is an example how device private CMA area can be activated.
> It creates one CMA region and assigns it to the first s5p-fimc device on
> Samsung Goni S5PC110 board.
> 
> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
