Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0D3QxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:53:00 -0400
Received: from mail.atmel.fr ([81.80.104.162]:53759 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757861Ab0D3Qwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:52:51 -0400
Message-ID: <4BD9391F.6070707@atmel.com>
Date: Thu, 29 Apr 2010 09:45:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.infradead.org,
       linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel@avr32linux.org
Subject: Re: [PATCH 1/4] MMC: atmel-mci: fix two parameters swapped
References: <bfa27c51250b39deeccbf6f3a656db4e0b73ce92.1272378853.git.nicolas.ferre@atmel.com>	<bfa27c51250b39deeccbf6f3a656db4e0b73ce92.1272378853.git.nicolas.ferre@atmel.com> <20100428112245.23e99d70.akpm@linux-foundation.org>
In-Reply-To: <20100428112245.23e99d70.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 28/04/2010 20:22, Andrew Morton :
> Patches 1-3 (at least) appear to be applicable to 2.6.33.x and perhaps
> earlier.

Correct.

> But you didn't cc stable@kernel.org and there was no Cc:
> <stable@kernel.org> in the changelog and in this case I'd prefer not to
> make that decision myself?

You are right. In fact I was waiting for feedback before pushing this
also to "stable"...

I keep this in mind and will do this when it will be merged in mainline.

Thanks, best regards,
-- 
Nicolas Ferre

