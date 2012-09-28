Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758509Ab2I1PRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:17:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56544 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758364Ab2I1PRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:17:06 -0400
MIME-Version: 1.0
In-Reply-To: <20120928150520.GK7916@n2100.arm.linux.org.uk>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	<CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	<CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
	<1348842668.1480.9.camel@anish-Inspiron-N5050>
	<CACVXFVPE1wwVhN=WobgZ+KfGRk2HifQ_3bhwF4mHS+Qu+bXh+g@mail.gmail.com>
	<20120928150520.GK7916@n2100.arm.linux.org.uk>
Date: Fri, 28 Sep 2012 23:17:04 +0800
Message-ID: <CACVXFVNrfvUg_=pNZvgicf62Ms6rBcFPKXdyb0K5RrjCxs2XNg@mail.gmail.com>
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: Ming Lei <ming.lei@canonical.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: anish kumar <anish198519851985@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:05 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Sep 28, 2012 at 10:44:13PM +0800, Ming Lei wrote:
>> On Fri, Sep 28, 2012 at 10:31 PM, anish kumar
>> <anish198519851985@gmail.com> wrote:
>>
>> > Ming,
>> > Somehow I feel here that the problem reported by Russell is totally
>> > different from your understanding of problem.I humbly urge you to have
>>
>> I let Russell answer if it is same problem, see my last email.
>
> I'm tired of this thread.  It's really not worth spending any more time
> on this crap.  You can't see the problem, and it seems you're unwilling
> to listen to the feedback that's being given to you.

Looks you did not reply my previous question, right? And you just said
it is wrong, and not mention what is wrong about my description.

          > Could you point out in detail what is wrong with my description?

OK, I understand that you think what my patch addressed is not same with
the problem you reported, so I will remove the reported-by.


Thanks,
--
Ming Lei
