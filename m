Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab2IJGr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 02:47:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52382 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2IJGr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 02:47:56 -0400
Date: Mon, 10 Sep 2012 02:47:51 -0400 (EDT)
Message-Id: <20120910.024751.2110848839896025221.davem@davemloft.net>
To: minipli@googlemail.com
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, gerrit@erg.abdn.ac.uk
Subject: Re: [ 35/95] dccp: check ccid before dereferencing
From: David Miller <davem@davemloft.net>
In-Reply-To: <CA+rthh8Z8panzcLT9baQd=qEvywfJcQVk1wCnHJ_PCBu=Rn5Tw@mail.gmail.com>
References: <20120909224150.641491654@decadent.org.uk>
	<20120909224155.647306922@decadent.org.uk>
	<CA+rthh8Z8panzcLT9baQd=qEvywfJcQVk1wCnHJ_PCBu=Rn5Tw@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>
Date: Mon, 10 Sep 2012 08:17:06 +0200

> Hi Ben,
> 
> On Mon, Sep 10, 2012 at 12:42 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> No objections, but could you please consider including the following
> commits, too?:

They will be included when I next push my networking -stable queue to
the stable maintainers, and no sooner.

You never need to ask if and when a networking patch will be submitted
to stable, my pending queue is always available for you to inspect
here:

http://patchwork.ozlabs.org/bundle/davem/stable/?state=*
