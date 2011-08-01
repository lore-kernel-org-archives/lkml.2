Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1HARUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 13:20:24 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:35076 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1HARUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 13:20:19 -0400
From: Richard Weinberger <richard@nod.at>
To: Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: shm updates broke UML
Date: Mon, 1 Aug 2011 19:20:15 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: Marc Zyngier <maz@misterjones.org>, serge.hallyn@canonical.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        user-mode-linux-devel@lists.sourceforge.net, toralf.foerster@gmx.de
References: <201108011541.59640.richard@nod.at> <43e4e9e98b32d3d3eb06ab837a019ad8@localhost> <20110801171042.GA25954@albatros>
In-Reply-To: <20110801171042.GA25954@albatros>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108011920.15972.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Montag 01 August 2011 19:10:42 Vasiliy Kulikov wrote:
> On Mon, Aug 01, 2011 at 18:01 +0200, Marc Zyngier wrote:
> > It also breaks ARM (at least 11MPCore and Cortex A9).
> > The same workaround gets the kernel booting again.
> 
> Can you please apply this patch and show the output?
> I suppose all numbers will be nonNULL and the last is NULL.

true. :-)

ns = 0824cc44, ids = 0824cc90
wait_list = 0824cc9c
next =   (null)

Thanks,
//richard
