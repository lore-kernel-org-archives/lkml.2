Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab1LUXaO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 18:30:14 -0500
Received: from merlin.infradead.org ([205.233.59.134]:52823 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863Ab1LUXaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 18:30:11 -0500
Subject: Re: linux-next: Tree for Dec 19 (nfc)
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linville@tuxdriver.com" <linville@tuxdriver.com>
In-Reply-To: <4EF2569D.1070806@xenotime.net>
References: <20111219185556.f07c1f43e28cfd594aaa5fe0@canb.auug.org.au>
	 <4EEFA21B.5010305@xenotime.net> <1324399181.5354.0.camel@sortiz-mobl>
	 <4EF23A1F.60803@xenotime.net> <1324500160.5354.3.camel@sortiz-mobl>
	 <4EF2569D.1070806@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Dec 2011 00:35:22 +0100
Message-ID: <1324510522.5354.5.camel@sortiz-mobl>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 13:58 -0800, Randy Dunlap wrote:
> On 12/21/2011 12:42 PM, Samuel Ortiz wrote:
> > Hi Randy,
> > 
> > On Wed, 2011-12-21 at 11:57 -0800, Randy Dunlap wrote:
> >> On 12/20/2011 08:39 AM, Samuel Ortiz wrote:
> >>> Hi Randy,
> >>>
> >>> On Mon, 2011-12-19 at 12:44 -0800, Randy Dunlap wrote:
> >>>> On 12/18/2011 11:55 PM, Stephen Rothwell wrote:
> >>>>> Hi all,
> >>>>>
> >>>>> Changes since 20111216:
> >>>>
> >>>>
> >>>> (not new today, just not reported earlier)
> >>> John applied my fix for this one. It should be fixed now.
> >>
> >> Hi Samuel,
> >>
> >> Is this supposed to be fixed in linux-next?
> >> It still fails today (linux-next 20111221).
> > Do you have a .config for me to look at ?
> 
> Sure, one of several that failed is attached.
Thanks, I just tried this one and it seems to work fine. What's your
toolchain ?
I'm using: gcc version 4.6.2 (Debian 4.6.2-4)

Cheers,
Samuel.


