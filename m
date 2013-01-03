Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3ACJvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 04:51:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50039 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753033Ab3ACJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 04:51:20 -0500
Date: Thu, 03 Jan 2013 01:51:16 -0800 (PST)
Message-Id: <20130103.015116.1184440964345015073.davem@davemloft.net>
To: sfr@canb.auug.org.au
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, sony.chacko@qlogic.com,
        sucheta.chakraborty@qlogic.com, sritej.velaga@qlogic.com
Subject: Re: linux-next: build failure after merge of the final tree
 (net-next tree related)
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130103142353.b4fee0ccd57730e4fbd63ba9@canb.auug.org.au>
References: <20130103142353.b4fee0ccd57730e4fbd63ba9@canb.auug.org.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Thu, 3 Jan 2013 14:23:53 +1100

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 3 Jan 2013 14:19:16 +1100
> Subject: [PATCH] qlcnic: do not duplicate infrastructure functions
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Applied.
