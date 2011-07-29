Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093Ab1G2Ao1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:44:27 -0400
Received: from outgw02.ricoh.co.jp ([202.248.73.5]:35391 "EHLO
	outgw02.ricoh.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685Ab1G2Ao0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:44:26 -0400
In-Reply-To: <20110729003703.GM8006@one.firstfloor.org>
Subject: Re: [PATCH] [9/50] mmc: Added quirks for Ricoh 1180:e823 lower base clock
To: andi@firstfloor.org
Cc: ak@linux.intel.com, andi@firstfloor.org, cjb@laptop.org,
        daniel.manrique@canonical.com, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, manoj.iyer@canonical.com,
        stable@kernel.org, tim.bird@am.sony.com
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF239A906D.A39CC1D2-ON492578DC.0003E8BE-492578DC.0004121C@mta.ricoh.co.jp>
From: matsumur@nts.ricoh.co.jp
Date: Fri, 29 Jul 2011 09:46:20 +0900
X-MIMETrack: Serialize by Router on ZGMTA07/G/RGroup(Release 7.0.2FP1 HF237|April 25, 2007) at
 2011/07/29 09:44:26
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's no misfunction. Just the wrong name.

Koji Matsumuro

Andi Kleen <andi@firstfloor.org> wrote on 2011/07/29 09:37:03:

> On Fri, Jul 29, 2011 at 09:27:56AM +0900, matsumur@nts.ricoh.co.jp wrote:
> > Dear Sir,
> >
> > Ricoh 1180:e823 device is named R5U220/R5U232 (2 devices have the same
> > device ID ).
> > So, I think it should be declared to as PCI_DEVICE_ID_RICOH_R5U220.

> Is that just the wrong name or will it actually cause misfunction?

> I will keep it if it's just the wrong name, but the name should be
probably
> fixed upstream.

> -Andi

