Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0KEVl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 17:41:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52268 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954Ab0KEVlz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 17:41:55 -0400
MIME-Version: 1.0
In-Reply-To: <20101105213456.GB25520@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr> <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr> <20101031122437.GA6296@quack.suse.cz>
 <20101031224012.GB13207@quack.suse.cz> <20101105213324.GA25520@quack.suse.cz> <20101105213456.GB25520@quack.suse.cz>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Nov 2010 14:41:33 -0700
Message-ID: <AANLkTimYJy8Yqtmqeg7DjnvPbfhq5LwY27mY8K+iGQFA@mail.gmail.com>
Subject: Re: Sync writeback still broken
To: Jan Kara <jack@suse.cz>
Cc: Jan Engelhardt <jengelh@medozas.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 5, 2010 at 2:34 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 05-11-10 22:33:24, Jan Kara wrote:
>>   I needed one more patch to resolve the issue (attached) which I've just
>> posted for review and possible inclusion. I had a similar one long time ago
>> but now I'm better able to explain why it works because of tracepoints.
>> Yay! ;). With those three patches I'm not able to trigger livelocks (but
>> sync takes still 15 minutes because the througput to disk is about 4MB/s -
>> no big surprise given the random nature of the load)
>  PS: And big thanks to you for providing the test case and your
> persistence ;)

Ok, I'm inclined to just apply these three patches. Can we get a quick
ack/tested-by for them? I'm sure there's more work to be done, but
let's put this damn thing to rest if it really does fix the problem
Jan(E) sees.

Comments?

                     Linus
