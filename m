Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0LRQxu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 11:53:50 -0500
Received: from relay2.mail.vrmd.de ([81.28.224.28]:53394 "EHLO
	relay2.mail.vrmd.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab0LRQxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 11:53:49 -0500
X-Greylist: delayed 1385 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Dec 2010 11:53:48 EST
Date: Sat, 18 Dec 2010 16:30:35 +0000
From: Thorsten Kranzkowski <dl8bcu@dl8bcu.de>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Why is networking GIT refusing me?
Message-ID: <20101218163035.GA1127@ds20.borg.net>
Reply-To: dl8bcu@dl8bcu.de
Mail-Followup-To: dl8bcu@dl8bcu.de, Piotr Hosowicz <piotr@hosowicz.com>,
	linux-kernel@vger.kernel.org
References: <4D0CDB28.8090809@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D0CDB28.8090809@example.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Relay-User: dl8bcu@dl8bcu.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 05:02:48PM +0100, Piotr Hosowicz wrote:
> Hello,
>
> I tried to update my Linux tree with the newest networking source vand 
> tried to run:
>
> git remote add networking 
> master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git master

you probably want to use 
git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6.git
for public, read only access.

> git remote update
>
> The second one asks me if the SSH key is valid, and then asks me for the 
> root password which I obviously do not know and cannot update. Where to get 
> newest networking source by GIT?
>
> Regards,
>
> Piotr Hosowicz

-- 
| Thorsten Kranzkowski        Internet: dl8bcu@dl8bcu.de                      |
| Mobile: ++49 170 1876134       Snail: Kiebitzstr. 14, 49324 Melle, Germany  |
| Ampr: dl8bcu@db0lj.#rpl.deu.eu, dl8bcu@marvin.dl8bcu.ampr.org [44.130.8.19] |
