Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935283Ab0KQUyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:54:45 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:58671 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757797Ab0KQUyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:54:44 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
Date: Wed, 17 Nov 2010 21:53:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc2-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201011171139.33398.linux@rainbow-software.org>
In-Reply-To: <201011171139.33398.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011172153.52644.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 17, 2010, Ondrej Zary wrote:
> Hello,
> the nasty memory-corrupting hibernation bug 
> https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since 2.6.35.5.
> 2.6.35.4 works fine, 2.6.35.5 crashes after two days.
> 
> It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.

Can you, _please_, always put all of the basic commit info (subject, author,
who signed it off) in bug reports?

In this particular case I don't have a -stable tree handy at the moment and
can't even see what the commit is.

Thanks,
Rafael
