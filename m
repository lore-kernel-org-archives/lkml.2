Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab1DMNPE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 09:15:04 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:35063 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1DMNPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 09:15:01 -0400
X-Greylist: delayed 737 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 09:15:01 EDT
Subject: Re: [PATCH 2/3] fix the wrong argument of the functions definition
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: wanlong.gao@gmail.com
Cc: chris@zankel.net, steiner@sgi.com, tglx@linutronix.de,
        akpm@linux-foundation.org, hch@lst.de, linux-kernel@vger.kernel.org
In-Reply-To: <1302416084-13372-2-git-send-email-wanlong.gao@gmail.com>
References: <1302416084-13372-1-git-send-email-wanlong.gao@gmail.com>
	 <1302416084-13372-2-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Wed, 13 Apr 2011 15:14:00 +0200
Message-ID: <1302700440.10549.1.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2011 13:14:03.0014 (UTC) FILETIME=[A8CA4260:01CBF9DC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-04-10 at 14:14 +0800, wanlong.gao@gmail.com wrote: 
> From: Wanlong Gao <wanlong.gao@gmail.com>
> 
> The functions of eic_chip's memebers use the wrong argument .
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>

Thanks for this fix, added to the AVR32 tree.

Signed-off-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>

<snipp patch>

-- 
Hans-Christian Egtvedt

