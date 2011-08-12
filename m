Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677Ab1HLVWo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:22:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16269 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1HLVWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:22:43 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 12 Aug 2011 14:22:37 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>
CC: Colin Cross <ccross@android.com>, Erik Gilling <konkers@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 12 Aug 2011 14:21:47 -0700
Subject: RE: [PATCH v2 0/3] ARM: Tegra: Harmony & Seaboard USB and audio
Thread-Topic: [PATCH v2 0/3] ARM: Tegra: Harmony & Seaboard USB and audio
Thread-Index: AcxWy0MChX673DdJTx2FH+2ZCVbY0QCaji6g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF04AEA24F49@HQMAIL01.nvidia.com>
References: <1312835715-893-1-git-send-email-swarren@nvidia.com>
 <20110809193405.GA4224@quad.lixom.net>
In-Reply-To: <20110809193405.GA4224@quad.lixom.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote at Tuesday, August 09, 2011 1:34 PM:
> On Mon, Aug 08, 2011 at 02:35:12PM -0600, Stephen Warren wrote:
> > This is a slight rev of some patches I posted a little while ago, now
> > in a single series. The second patch has a minor revision that simplifies
> > board-seaboard-pinmux.c.
> >
> > The (previous version of the) patches were previously Ack'd by Tegra
> > maintainers, and Colin asked Arnd to pick them up in arm-soc.git,
> > although I'm not sure if that request still holds given the merge
> > window is over?
> 
> Thanks, I've picked them up in boards-for-3.2, which will be merged in
> through Arnd for 3.2.

I see boards-for-3.2 isn't in linux-next itself, so these changes aren't
getting rebased out of my local tree on top of linux-next.

Does it make sense to add your tree into linux-next? Or, is the expected
process that such trees will be quickly pulled/merged into Arnd's tree,
which I assume is in linux-next?

Thanks.

-- 
nvpublic

