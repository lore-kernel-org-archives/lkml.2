Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab2HXFey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 01:34:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61240 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2HXFew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 01:34:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAB=NE6Xg=NUsb-hQyxr+-RyzpkJ-BH6RbbcTX6KF23H+u4yEPQ@mail.gmail.com>
References: <1345480949-14800-1-git-send-email-cjren@qca.qualcomm.com>
 <20120822.225700.714020017287504609.davem@davemloft.net> <157393863283F442885425D2C45428562A4F5169@nasanexd02f.na.qualcomm.com>
 <1345756142.2579.16.camel@bwh-desktop.uk.solarflarecom.com>
 <157393863283F442885425D2C45428562A4F54E3@nasanexd02f.na.qualcomm.com>
 <1345774184.2579.51.camel@bwh-desktop.uk.solarflarecom.com>
 <157393863283F442885425D2C45428562A4F5546@nasanexd02f.na.qualcomm.com> <CAB=NE6Xg=NUsb-hQyxr+-RyzpkJ-BH6RbbcTX6KF23H+u4yEPQ@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Fri, 24 Aug 2012 10:34:30 +0500
X-Google-Sender-Auth: 56wi9rm0mitGQElkLLiDKgH7ZrA
Message-ID: <CAB=NE6UOG-i6O48Z+EUMgo=zTvGiGGTd9A0O-MiTJ+FnyMB_2w@mail.gmail.com>
Subject: Re: [PATCH v2] net: add new QCA alx ethernet driver
To: "Huang, Xiong" <xiong@qca.qualcomm.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        David Miller <davem@davemloft.net>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        nic-devel <nic-devel@qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2012 at 8:32 AM, Luis R. Rodriguez
<rodrigue@qca.qualcomm.com> wrote:
> It would be useful for you to describe the exact functionality,
> perhaps in a separate thread or maybe even just RFC patches which you
> have to be simply ready for may just be just that -- RFC patches which
> we flush down the v2 toilet.

A simple strategy for you is for you to remove this code (if present)
for now and then throw into a crap/ patch [0] under compat-drivers but
with an objective of eventually going through the RFC stages to get
this properly merged upstream.

[0] https://backports.wiki.kernel.org/index.php/Documentation/compat-drivers/additional-patches

  Luis
