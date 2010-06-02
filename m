Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab0FBHgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 03:36:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34624 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab0FBHgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 03:36:15 -0400
Message-ID: <4C0609F2.10802@vflare.org>
Date: Wed, 02 Jun 2010 13:06:18 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>, Ed Tomlinson <edt@aei.ca>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] Support generic I/O requests
References: <1275379286-10453-1-git-send-email-ngupta@vflare.org>	<1275379286-10453-2-git-send-email-ngupta@vflare.org> <AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
In-Reply-To: <AANLkTimjc8eZY2IqbeZUR7VsWVspZ4ilUz3LPAUIiZuU@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 11:50 AM, Minchan Kim wrote:
> On Tue, Jun 1, 2010 at 5:01 PM, Nitin Gupta <ngupta@vflare.org> wrote:


> P.S)
> Why don't you send this series to -mm?

In general, zram is somewhat related to memory management but these zram
patches mainly deal with handling generic I/O requests. So, I just posted
them on linux-kernel. Even if changes were made to xvmalloc, I doubt
if anyone at -mm would be interested in a driver specific allocator.

> I don't know any patches have to go linux-next and any patches have to
> go --mmotm.
> I thought zram is related to memory management a little bit.
> 
> What's the criteria?
> 

I *guess* anything experimental goes to linux-next and if thats related
directly to core mm, it goes to --mmotm also.

Thanks,
Nitin
