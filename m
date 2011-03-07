Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1CGPPt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 10:15:49 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:33087 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1CGPPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 10:15:47 -0500
Date: Mon, 7 Mar 2011 10:12:01 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Justin Mattock <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        ath9k-devel@atheros.com
Subject: Re: WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
 ath_stoprecv+0xc8/0xda [ath9k]()
Message-ID: <20110307151201.GC2664@tuxdriver.com>
References: <AANLkTik9To0Rkq2FRqQFB2wNu0kyJ7CzyBek2jBp36Cb@mail.gmail.com>
 <20110303135942.GA8969@tuxdriver.com>
 <AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=mtaf==aLfOFK06EgmbdZ4aVk3GEthw7PwuSTS@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 06, 2011 at 12:47:05AM -0800, Justin Mattock wrote:

> full dmesg here:
> http://fpaste.org/5JQp/
> let me know if I need to supply any info(also I can try a bisect, but
> am in the middle of changing residencies, so it might not be right
> away)

One of the Atheros guys suggested that you change a DMA timeout value.
Did you try that?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
