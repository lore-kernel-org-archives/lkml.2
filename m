Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0GMKWo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 06:22:44 -0400
Received: from smtp.nokia.com ([192.100.122.233]:39313 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756521Ab0GMKWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 06:22:39 -0400
Subject: Re: [PATCH 01/25] r852: remove casts from void*
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mtd@lists.infradead.org, Tejun Heo <tj@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1277806498-30738-1-git-send-email-segooon@gmail.com>
References: <1277806498-30738-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Jul 2010 12:57:56 +0300
Message-ID: <1279015076.31639.20.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 13 Jul 2010 10:02:56.0627 (UTC) FILETIME=[911AF430:01CB2272]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-29 at 14:14 +0400, Kulikov Vasiliy wrote:
> Remove unnesessary casts from void*.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Pushed whole series to l2-mtd-2.6.git / master.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

