Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0HXRhr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 13:37:47 -0400
Received: from www17.your-server.de ([213.133.104.17]:52083 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0HXRho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 13:37:44 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Roberto Oppedisano <roberto.oppedisano@gmail.com>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
Date: Tue, 24 Aug 2010 19:36:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc2-00003-g9ee4747; KDE/4.4.5; i686; ; )
Cc: Paul Rolland <rol@as2917.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        "Xiang Hai hao" <haihao.xiang@intel.com>,
        Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
References: <201008011101.01429.thomas@m3y3r.de> <20100801151409.252be86b@tux.DEF.witbe.net> <4C559022.1010406@gmail.com>
In-Reply-To: <4C559022.1010406@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008241936.18681.thomas@m3y3r.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 01 August 2010 17:17:54 Roberto Oppedisano wrote:
>   On 01/08/2010 15:14, Paul Rolland wrote:
> > My machine has :
> > 00:02.0 0300: 8086:2a42 (rev 07)
> > 00:02.1 0380: 8086:2a43 (rev 07)
> >
> > 00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> > 00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset Integrated Graphics Controller (rev 07)
> >
> > (Dell Vostro 1520, BIOS Revision A04)
> >
> >>>   Is it suspend
> >>> or resume that is unreliable?
> >> suspend never finishes/hangs.

Seems to be fixed in 2.6.36-rc2. Probably by merge commit 
4238a417a91643e1162a98770288f630e37f0484.

Paul, Roberto: Could you please confirm this on your hardware?

kind regards
thomas
