Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab0G1ViW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:38:22 -0400
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:50312 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751136Ab0G1ViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:38:19 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Memory corruption during hibernation since 2.6.31
Date: Wed, 28 Jul 2010 23:38:09 +0200
User-Agent: KMail/1.9.10
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
References: <201007282320.39528.linux@rainbow-software.org> <201007282334.08063.rjw@sisk.pl>
In-Reply-To: <201007282334.08063.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007282338.12098.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 July 2010 23:34:07 Rafael J. Wysocki wrote:
> On Wednesday, July 28, 2010, Ondrej Zary wrote:
> > Hello,
> > after very long bisection, I finally found what's causing memory
> > corruption during hibernation on my machine sice 2.6.31:
> > https://bugzilla.kernel.org/show_bug.cgi?id=15753
> >
> > It's commit c9e444103b5e7a5a3519f9913f59767f92e33baf (mm: reuse unused
> > swap entry if necessary).
> >
> > I don't know anything about swapping in Linux so I don't have a clue
> > what's wrong with that commit.
>
> Thanks for bisecting!
>
> This looks rather serious.  I'd be grateful from any clues from the mm guys
> involved (CCed).
>
> Do you use s2disk or the built-in hibernation code?

I use built-in code (echo disk >/sys/power/state). The machine has 256MB RAM 
and 256MB swap partition.

-- 
Ondrej Zary
