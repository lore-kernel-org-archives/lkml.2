Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303Ab2CEVyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:54:05 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56732 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754065Ab2CEVyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:54:03 -0500
Date: Mon, 05 Mar 2012 16:53:58 -0500 (EST)
Message-Id: <20120305.165358.1299012386498157182.davem@davemloft.net>
To: santoshprasadnayak@gmail.com
Cc: jitendra.kalsaria@qlogic.com, ron.mercer@qlogic.com,
        linux-driver@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/3] qla3xxx: ethernet: Silence static checker warning.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1330700979-18231-1-git-send-email-santoshprasadnayak@gmail.com>
References: <1330700979-18231-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 05 Mar 2012 13:54:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: santosh nayak <santoshprasadnayak@gmail.com>
Date: Fri,  2 Mar 2012 20:39:39 +0530

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> Silence the following warning:
> "warn: returning -1 instead of -ENOMEM is sloppy".
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>

Applied.
