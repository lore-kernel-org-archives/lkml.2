Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab1KRN3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 08:29:42 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47295 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab1KRN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 08:29:41 -0500
Date: Fri, 18 Nov 2011 11:30:17 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>, linux-bluetooth@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 17 (bluetooth)
Message-ID: <20111118133017.GA2131@joana>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org
References: <20111117150733.a70faf2c9030d511d5367e1e@canb.auug.org.au>
 <4EC5496F.2080509@xenotime.net>
 <20111118095855.GB9034@aemeltch-MOBL1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118095855.GB9034@aemeltch-MOBL1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrei,

* Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com> [2011-11-18 11:58:58 +0200]:

> Hi Randy,
> 
> On Thu, Nov 17, 2011 at 09:50:39AM -0800, Randy Dunlap wrote:
> > On 11/16/2011 08:07 PM, Stephen Rothwell wrote:
> > > Hi all,
> > 
> > 
> > When CONFIG_BT_L2CAP is not enabled:
> > 
> > net/built-in.o: In function `hci_dev_open':
> > (.text+0xdce9a): undefined reference to `enable_hs'
> 
> Despite not enabling L2CAP sounds strange we might find solution even for
> this usage :-)
> I am thinking about moving enable_hs to common part not depending on
> CONFIG_BT_L2CAP option:

This is ok, please send a proper git patch so I can apply it.

	Gustavo
