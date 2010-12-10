Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0LJUwZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 15:52:25 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40036
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756855Ab0LJUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 15:52:24 -0500
Date: Fri, 10 Dec 2010 12:52:52 -0800 (PST)
Message-Id: <20101210.125252.212677124.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-12-10
From: David Miller <davem@davemloft.net>
In-Reply-To: <20101210202902.GG4296@tuxdriver.com>
References: <20101210202902.GG4296@tuxdriver.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 10 Dec 2010 15:29:03 -0500

> Here is the latest round of wireless bits intended for 2.6.37...
> 
> Included are some orinoco fixes, one to avoid the crash in bug 23932 and
> two others that render TKIP countermeasures ineffective (i.e. decreased
> security).  Helmut has provided us a fix to avoid a BUG when using
> shared skbs.  The ath9k team gives us a fix for failed resumes on
> ath9k_htc, a fix for detecting broadcast frames with a MIC failure, a
> fix for a null pointer access when generating beacons, and a DMA issue
> that can lead to memory corruption.  Matteo Croce pitches-in with a fix
> to prevent transmitting with too much power.  Finally,  Javier Cardona
> provides a trio of ath5k fixes that restore mesh function on those
> devices.
> 
> Please let me know if there are problems!

Pulled, thanks John.
