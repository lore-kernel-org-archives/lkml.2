Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2FGUoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 16:44:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50626 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256Ab2FGUoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 16:44:04 -0400
Message-ID: <4FD11292.10700@tilera.com>
Date: Thu, 7 Jun 2012 16:44:02 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <eric.dumazet@gmail.com>, <bhutchings@solarflare.com>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v10] tilegx network driver: initial support
References: <4FCFA312.4020505@tilera.com> <20120606.115440.1245419453265419850.davem@davemloft.net> <201206072031.q57KV0NG029301@farm-0023.internal.tilera.com> <20120607.133900.1764130639940088009.davem@davemloft.net>
In-Reply-To: <20120607.133900.1764130639940088009.davem@davemloft.net>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/7/2012 4:39 PM, David Miller wrote:
> From: Chris Metcalf <cmetcalf@tilera.com>
> Date: Fri, 6 Apr 2012 16:42:03 -0400
>
>> Date: Fri, 6 Apr 2012 16:42:03 -0400
> You did not commit this file on April 6th.
>
> Please don't use the date emitted by the GIT tools, just
> let the email use the natural correct date which is the
> one at the time you send the email out.
>
> Otherwise your patch gets misordered as automated tools like
> patchwork think this file should go all the way at the back
> of the patch queue because of it's old date relative to
> other pending patches.

Yes, when I use "git rebase" to merge changes into the earlier patch, this
is the behavior I see.  I don't know if there's some way to tell git to
take the date on the later change instead when I "squash" them.  Or if,
perhaps, there is some other workflow I should be using.  It does seem like
the git history should reflect the latest time.

The issue of the date on the email is separate.  I tend to use "git
format-patch" to start with, munge up the headers to jam in some
"In-Reply-To" and "References" lines, manually update the "Date:", then
feed it to "sendmail -t".  Perhaps there's a different workflow I should be
using there, too.  (I tried deleting the "Date", but the one time I tried
that I ended up with some surprisingly bogus date in the email that hit
LKML, so I've been avoiding that approach.)

I'll resend the patch without a Date: line and see how it ends up this time.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

