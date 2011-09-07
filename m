Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756990Ab1IGVDr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 17:03:47 -0400
Received: from cassarossa.samfundet.no ([129.241.93.19]:40900 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756519Ab1IGVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 17:03:46 -0400
X-Greylist: delayed 2019 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 17:03:46 EDT
Date: Wed, 7 Sep 2011 22:29:59 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 05/62] avr32: irq: Remove IRQF_DISABLED
Message-ID: <20110907202959.GA23856@samfundet.no>
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-6-git-send-email-yong.zhang0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315383059-3673-6-git-send-email-yong.zhang0@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Wed 07 Sep 2011 16:10:02 +0800 or thereabout, Yong Zhang wrote:
> This flag is a NOOP and can be removed now.
> 

Oki.

> Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
>

Thanks.

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
