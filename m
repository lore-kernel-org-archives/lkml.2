Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0CUMjy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 08:39:54 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49336 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab0CUMjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 08:39:53 -0400
Message-ID: <4BA61384.3030005@cs.helsinki.fi>
Date: Sun, 21 Mar 2010 14:39:32 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Lars Lindley <lindley@coyote.org>, Dan Carpenter <error27@gmail.com>,
       gregkh@suse.de, greg@kroah.com, harvey.harrison@gmail.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: reg.c Coding style fixes.
References: <1269098051-6594-1-git-send-email-lindley@coyote.org> <20100320162426.GB28881@bicker> <4BA5204C.9050208@coyote.org> <20100321065814.GB11917@elf.ucw.cz>
In-Reply-To: <20100321065814.GB11917@elf.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
>> [PATCH] staging: winbond: reg.c Fix accidental commenting of msleep(10)
>>
>> I accidentaly commented out msleep() in one place.
>> This applies after previous patch:
>> Message-Id: <1269098051-6594-1-git-send-email-lindley@coyote.org>
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
> 
> Ack. but you probably want to merge those two pieces together.

Yes. Like I said before, please _check_ the result before posting your 
patches. It's very easy to make silly mistakes in "trivial" patches like 
these. Remember, it's not about quantity, it's about quality of each 
individual patch no matter how trivial they might seem at first.

			Pekka
