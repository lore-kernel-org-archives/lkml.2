Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab0HURsm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 13:48:42 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34890 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab0HURsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 13:48:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=eBPNMtU6t6k7tXKw2ZZR0MXBm6MiKb2GV6U06DulsmXfrpJIXm+qUNnhs23+7EvA7y
         cptYsM5OZCkHFHQNcqwUtBWvxVu2bNBFZHbmuzJ33ifUXHQi969xKJ/W92f/JwSP4WGY
         XHf4eD3e6ZwHUYsNWj2P/aqb35oOrEvEXcozk=
Subject: Re: [PATCH 0/6] improve list_sort test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: don.mullis@gmail.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87lj7zgaw8.fsf@gmail.com>
References: <1281168645-18413-1-git-send-email-dedekind1@gmail.com>
	 <1282386155.2358.43.camel@localhost>  <87lj7zgaw8.fsf@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 21 Aug 2010 20:48:36 +0300
Message-ID: <1282412916.2269.1.camel@brekeke>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-08-21 at 09:59 -0700, don.mullis@gmail.com wrote:
> Thanks, Artem.  I've prepared and tested locally a patch series that
> brings in most of the series you sent earlier, and adds a few more
> cleanups.  The one patch of yours that I did replace was the last one,
> that modifies semantics of the correctness test.  My reasoning is that
> the value of testing lies in exposing bugs, as economically as possible,
> and your test wasn't exposing my power-of-two bug.  So I created an
> alternative that's as simple as possible while picking at the corner
> cases, e.g. power-of-two.

That's fine, thanks.

> Last in my local patch series is the bug fix itself.  Setting
> CONFIG_TEST_LIST_SORT and testing with all but the last patch applied
> produces failure messages on the boot console.  Pushing the final "fix"
> patch makes them go away :-)

Sounds good.

> Okay if I incorporate your comment addition, above, and post the series
> for review?

Sure, I'll be happy if you take care of this, just keep me in CC when
you submit the patches, please.

Thanks,
Artem.

