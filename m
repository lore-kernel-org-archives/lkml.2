Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758927Ab0E1VLZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:11:25 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:64760 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689Ab0E1VLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:11:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eFCbk94S+ZBAeUP/fzrdnYxecWGzZ0W1C2KLbY/hmPITpdlO9v8MoRhxnYQxiqxFjy
         Q6W/F1NyV/DmMXszBKBvmVOo0Dos0CZxy0Ed8d2p6WnV+L7ebWWLJE96PqCHkxhk35d+
         BdF9MalNVE3mIs35q6WkqQIyckfPYuVYho5VQ=
Date: Fri, 28 May 2010 23:05:42 +0200
From: Fredrik Gustafsson <iveqy@iveqy.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: hex_to_bin speedup
Message-ID: <20100528210542.GG28651@iveqy.com>
References: <20100527100729.GA21454@iveqy.com>
 <AANLkTinn7aEv0ueW4uRN06XdUbEltTfmjRXEABMRN-7e@mail.gmail.com>
 <20100527142848.GA23543@iveqy.com>
 <AANLkTinZUTSADw44UJ2g98AFCzs15DVt6zqLYr61HEaS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinZUTSADw44UJ2g98AFCzs15DVt6zqLYr61HEaS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 07:35:05PM +0300, Andy Shevchenko wrote:
> > [1] Benchmark results
> > $ gcc -O2 main.c && ./a.out
> > tolower() was faster 2657 times
> > if-statement was faster 2571 times
> > Equal fast 4772 times
> So, optimizer do the job for tolower(). Thus, nothing to worry about.
Yes I guess so. I tested with -Os too and that also does the trick.
Thank you for your time.

--
iveqy
