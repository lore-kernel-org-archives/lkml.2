Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1J1DPb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 23:15:31 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:49203 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754094Ab1J1DPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 23:15:30 -0400
Date: Thu, 27 Oct 2011 23:15:20 -0400 (EDT)
Message-Id: <20111027.231520.698587739433841485.davem@davemloft.net>
To: mitsuo.hayasaka.hu@hitachi.com
Cc: fubar@us.ibm.com, netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        shemminger@vyatta.com, andy@greyhouse.net,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH net -v2] [BUGFIX] bonding: use flush_delayed_work_sync
 in bond_close
From: David Miller <davem@davemloft.net>
In-Reply-To: <4EAA0ADF.5020504@hitachi.com>
References: <4EA4E2EE.4050201@hitachi.com>
	<2216.1319650260@death>
	<4EAA0ADF.5020504@hitachi.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 27 Oct 2011 20:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: HAYASAKA Mitsuo <mitsuo.hayasaka.hu@hitachi.com>
Date: Fri, 28 Oct 2011 10:52:31 +0900

> I checked your patch, and any problems have not been observed for
> almost one day although I could reproduce the BUG in the latest net-next
> without it. 
> 
> I think this patch works well.
> 
> Tested-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>

Jay, please formally submit this patch with proper signoffs etc.

Thanks!
