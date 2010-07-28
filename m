Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756321Ab0G1VfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:35:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40534 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753101Ab0G1VfL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:35:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: Memory corruption during hibernation since 2.6.31
Date: Wed, 28 Jul 2010 23:34:07 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc6-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201007282320.39528.linux@rainbow-software.org>
In-Reply-To: <201007282320.39528.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007282334.08063.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 28, 2010, Ondrej Zary wrote:
> Hello,
> after very long bisection, I finally found what's causing memory corruption 
> during hibernation on my machine sice 2.6.31:
> https://bugzilla.kernel.org/show_bug.cgi?id=15753
> 
> It's commit c9e444103b5e7a5a3519f9913f59767f92e33baf (mm: reuse unused swap 
> entry if necessary).
> 
> I don't know anything about swapping in Linux so I don't have a clue what's
> wrong with that commit.

Thanks for bisecting!

This looks rather serious.  I'd be grateful from any clues from the mm guys
involved (CCed).

Do you use s2disk or the built-in hibernation code?

Rafael
