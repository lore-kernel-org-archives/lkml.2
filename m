Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0KGXFM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 18:05:12 -0500
Received: from one.firstfloor.org ([213.235.205.2]:42203 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab0KGXFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 18:05:10 -0500
Date: Mon, 8 Nov 2010 00:05:09 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Matt <jackdachef@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        htd@fancy-poultry.org
Subject: Re: [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on 2.6.37-rc* ?
Message-ID: <20101107230508.GB17592@basil.fritz.box>
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com>
 <4CD6B7FA.3050005@redhat.com>
 <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com>
 <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com>
 <20101107194547.GA12521@basil.fritz.box>
 <4CD71C8B.1050604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD71C8B.1050604@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 07, 2010 at 10:39:23PM +0100, Milan Broz wrote:
> On 11/07/2010 08:45 PM, Andi Kleen wrote:
> >> I read about barrier-problems and data getting to the partition when
> >> using dm-crypt and several layers so I don't know if that could be
> >> related
> > 
> > Barriers seem to be totally broken on dm-crypt currently.
> 
> Can you explain it?

e.g. the btrfs mailing list is full of corruption reports
on dm-crypt and most of the symptoms point to broken barriers.

> Barriers/flush change should work, if it is broken, it is not only dm-crypt.
> (dm-crypt simply relies on dm-core implementation, when barrier/flush
> request come to dmcrypt, all previous IO must be already finished).

Possibly, at least it doesn't seem to work.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
