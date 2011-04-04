Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1DDKJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:09:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37889 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753642Ab1DDKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:09:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Ch3wc2MMMcW0sAOOmawHaLT57O8Q3AnhP/FOMHxUY58pRYQBIIk7lV1iywvsqcgW7D
         L6SGozZOQYeO2y+RnHs0give5Qqt71vXqQO1qpytZD/VFDFBS2ufUbZjphyYVh9RE3I0
         rc7O1I5RE1uBtRQHJaNsdw2ep2Th4qLVHu49w=
Subject: Re: [PATCH] ubifs: Use empty_iops and empty_fops consistently
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: sedat.dilek@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@nokia.com>,
        Jens Axboe <jaxboe@fusionio.com>
In-Reply-To: <BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
References: <1301874939-2630-1-git-send-email-sedat.dilek@gmail.com>
	 <1301900656.2760.6.camel@localhost>
	 <BANLkTi=WTWa4yj+ysta8jiHs9r4MX5Gf_g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 13:06:44 +0300
Message-ID: <1301911604.2760.52.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 11:38 +0200, Sedat Dilek wrote:
> Sorry for having flooded your inbox.

That's ok! :-) I think I did not look carefully enough. Your patch is
just an additional clean-up which makes the names to be consistent. I
can pick it, but probably it is better if it goes in with the
'empty_aops' changes? Whatever you prefer.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

