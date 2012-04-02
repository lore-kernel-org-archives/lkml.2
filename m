Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab2DBUkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:40:00 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:10838 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab2DBUj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:39:59 -0400
Message-ID: <1333399194.6431.3.camel@lorien2>
Subject: Re: [PATCH v5] ramoops: use pstore interface
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Mon, 02 Apr 2012 14:39:54 -0600
In-Reply-To: <4F1A7854.7010808@gmail.com>
References: <20120117235852.GA4877@www.outflux.net>
	 <20120118140603.0fc22302.akpm@linux-foundation.org>
	 <CAGXu5jKiPaChjvjA7r12mSH2W0r-X4EdFpQMMMaBOL+C=3UftA@mail.gmail.com>
	 <5C4C569E8A4B9B42A84A977CF070A35B2DA7A7F226@USINDEVS01.corp.hds.com>
	 <CAGXu5jJ3WMUDS0svkoviLx <4F1A7854.7010808@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> First of all ramoops was born mainly for debug purpose and to help the 
> maintainability of a product. I used it in systems where the uptime (so 
> no reboot) was important. So it can be very useful for me load the 
> module, gather logs and unload it for example. A kernel panic is not 
> recoverable so the reboot is needed but it's not always true for a 
> kernel oops.
> 
> Marco

What is the status of this patch? Don't see it in 3.3 and haven't
checked 3.4-rc1 yet.

-- Shuah

