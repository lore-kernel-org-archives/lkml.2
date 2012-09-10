Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2IJHLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:11:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46896 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab2IJHK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120910.024751.2110848839896025221.davem@davemloft.net>
References: <20120909224150.641491654@decadent.org.uk>
	<20120909224155.647306922@decadent.org.uk>
	<CA+rthh8Z8panzcLT9baQd=qEvywfJcQVk1wCnHJ_PCBu=Rn5Tw@mail.gmail.com>
	<20120910.024751.2110848839896025221.davem@davemloft.net>
Date: Mon, 10 Sep 2012 09:10:56 +0200
Message-ID: <CA+rthh_LtfxRVzRe2UuBbQkD4aFvqFRMDExkC64b4dRfnzKf1w@mail.gmail.com>
Subject: Re: [ 35/95] dccp: check ccid before dereferencing
From: Mathias Krause <minipli@googlemail.com>
To: David Miller <davem@davemloft.net>
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gerrit@erg.abdn.ac.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 8:47 AM, David Miller <davem@davemloft.net> wrote:
> From: Mathias Krause <minipli@googlemail.com>
> Date: Mon, 10 Sep 2012 08:17:06 +0200
>
>> Hi Ben,
>>
>> On Mon, Sep 10, 2012 at 12:42 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>>> 3.2-stable review patch.  If anyone has any objections, please let me know.
>>
>> No objections, but could you please consider including the following
>> commits, too?:
>
> They will be included when I next push my networking -stable queue to
> the stable maintainers, and no sooner.
>
> You never need to ask if and when a networking patch will be submitted
> to stable, my pending queue is always available for you to inspect
> here:
>
> http://patchwork.ozlabs.org/bundle/davem/stable/?state=*

Thanks for clarifying this and the pointer to the queue! I wasn't aware of it.

Mathias
