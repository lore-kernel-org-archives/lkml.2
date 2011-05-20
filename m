Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849Ab1ETTOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 15:14:32 -0400
Received: from smtp15.mail.ru ([94.100.176.133]:54155 "EHLO smtp15.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964781Ab1ETTO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 15:14:29 -0400
Date: Fri, 20 May 2011 23:14:27 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Paul Parsons <lost.distance@yahoo.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH] ds2760_battery: Fix rated capacity of the hx4700 1800mAh
 battery
Message-ID: <20110520191427.GA28601@rainbow>
References: <20110520174546.GA27734@rainbow>
 <931974.15363.qm@web29013.mail.ird.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <931974.15363.qm@web29013.mail.ird.yahoo.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:34 Fri 20 May     , Paul Parsons wrote:
> 
> If anybody here does have an hx4700 with the 3600mAh battery and is able to run Linux on it, it would be a big help if they could apply the following patch to discover the rated capacity register value via dmesg:

Yes, thanks! I'll try to revive my extended battery soon and test it. And
will test standard one too - just to make coverage a bit wider. Who
knows if HP produced more than one kind of standard capacity batteries
which have different value in capacity register?

> Or perhaps HaRET has some means of dumping the register?

No, I don't think HaRET have any one-wire functions, so it's very unlikely
that it can read registers on DS2760.

-- 
Best regards,
Dmitry "MAD" Artamonow

