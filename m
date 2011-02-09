Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab1BIWBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 17:01:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41733 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751010Ab1BIWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 17:01:39 -0500
MIME-Version: 1.0
In-Reply-To: <20110209.135751.112605587.davem@davemloft.net>
References: <20110209092419.2b335697.randy.dunlap@oracle.com>
 <AANLkTimUg8Dm9mZotubcgPHz8_at=_hnbeWUo-LfSALp@mail.gmail.com>
 <20110209132529.76927f5f.randy.dunlap@oracle.com> <20110209.135751.112605587.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 9 Feb 2011 14:00:48 -0800
Message-ID: <AANLkTikyPaFi96zrEbszFZzeB8UA-NWkjWFu2d_7X=EF@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc4 (hysdn: BUG)
To: David Miller <davem@davemloft.net>
Cc: randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, isdn@linux-pingi.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 1:57 PM, David Miller <davem@davemloft.net> wrote:
>
> I propose we just kill this stuff off completely.
>
> I note that there is code in other places of this driver that copy
> the read-only revision string into a local string buffer then pass
> it into the hysdn_getrev() function, it just doesn't happen in this
> one spot.
>
> Anyways, I think I'll fix this like so:

Ack from me. Removing terminally buggy and pointless code is certainly
better than trying to fix it up. No amount of lipstick will make that
pig look good.

                      Linus
