Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2GFBHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 21:07:45 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:27258 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab2GFBHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 21:07:43 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6763"; a="207839949"
X-IronPort-AV: E=Sophos;i="4.77,533,1336374000"; 
   d="scan'208";a="284256617"
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <20470.14858.754361.629383@gargle.gargle.HOWL>
Date: Fri, 6 Jul 2012 06:36:18 +0530
To: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
CC: Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "Balasubramanian, Senthil Kumar" <senthilb@qca.qualcomm.com>,
        "Manoharan, Rajkumar" <rmanohar@qca.qualcomm.com>,
        qca-linux-team <qca-linux-team@qualcomm.com>,
        Imran Ansari <imran@qca.qualcomm.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sfr@canb.auug.org.au>, <mcgrof@frijolero.org>, <hauke@hauke-m.de>,
        <ozancag@gmail.com>, <pstew@google.com>, <warthog9@kernel.org>,
        <jrnieder@gmail.com>, <ben@decadent.org.uk>,
        <akpm@linux-foundation.org>, <gregkh@linuxfoundation.org>,
        <linville@tuxdriver.com>
Subject: Re: 3.5 stable compat-wireless
In-Reply-To: <20120705190801.GB11228@tux>
References: <20468.35601.132955.802881@gargle.gargle.HOWL>
	<7A9ADFFA56024346AAE90B6BABC3BD15DD6DEB@NASANEXD02B.na.qualcomm.com>
	<20469.13787.767293.602337@gargle.gargle.HOWL>
	<20120705190801.GB11228@tux>
X-Mailer: VM 8.2.0b under 24.1.1 (x86_64-unknown-linux-gnu)
X-Originating-IP: [172.30.39.5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis R. Rodriguez wrote:
> > To make internal releases, I do something like this:
> > 
> > * Maintain a 'linux-foo-pending' branch, add pending patches and kick out releases
> >   for immediate testing.
> 
> A linux-foo-pending branch of linux-next.git ?

No, in compat-wireless - not in upstream, but in my 'forked' tree.
This is just to avoid the shuttling of patches between linux-next-pending/
and linux-next-cherry-picks/.

Sujith
