Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0KHORE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 09:17:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0KHORC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 09:17:02 -0500
Date: Mon, 8 Nov 2010 14:16:36 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Milan Broz <mbroz@redhat.com>, Matt <jackdachef@gmail.com>,
        dm-devel@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        htd@fancy-poultry.org
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs v3 on
	2.6.37-rc* ?
Message-ID: <20101108141635.GD15253@agk-dp.fab.redhat.com>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Milan Broz <mbroz@redhat.com>, Matt <jackdachef@gmail.com>,
	dm-devel@redhat.com, Linux Kernel <linux-kernel@vger.kernel.org>,
	htd@fancy-poultry.org
References: <AANLkTim6WTCChWGbTb-PUGd2AERGibeRtgan-WDznf2s@mail.gmail.com> <4CD6B7FA.3050005@redhat.com> <AANLkTikbsU+SGAaoq_oek=7tfDdjg+0wFoydhA+K9ZU+@mail.gmail.com> <AANLkTinna7BiGHogXnn1iEG6ccUAjFM3p3S3aHpv=h-E@mail.gmail.com> <20101107194547.GA12521@basil.fritz.box> <4CD71C8B.1050604@redhat.com> <20101107230508.GB17592@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107230508.GB17592@basil.fritz.box>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 12:05:09AM +0100, Andi Kleen wrote:
> e.g. the btrfs mailing list is full of corruption reports
> on dm-crypt and most of the symptoms point to broken barriers.

linux-btrfs?  I'm not subscribed, but I the searches I've tried
don't show it to be "full of corruption reports".

Could you post links to the threads concerned so we can investigate?

Are we just talking -rc1 or earlier too?

Thanks,
Alasdair

