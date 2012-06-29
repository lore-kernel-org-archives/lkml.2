Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab2F2Gq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:46:26 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:58844 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210Ab2F2GqY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:46:24 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Per ELLEFSEN <per.ellefsen@stericsson.com>,
        Kim LILLIESTIERNA <kim.xx.lilliestierna@stericsson.com>
Date: Fri, 29 Jun 2012 08:46:04 +0200
Subject: RE: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: Ac1TUYw0XNIkDhiOQU24vnH40OO88QCcN0xg
Message-ID: <81C3A93C17462B4BBD7E272753C10579232F86B36C@EXDCVYMBSTM005.EQ1STM.local>
References: <20120626131543.21e4338894b19f5e02f8bdde@canb.auug.org.au>
In-Reply-To: <20120626131543.21e4338894b19f5e02f8bdde@canb.auug.org.au>
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

Hi Stephen,

> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/caif/caif_hsi.c between commits 3935600a7f34 ("caif-hsi:
> Bugfix - Piggyback'ed embedded CAIF frame lost") and 1fdc7630b2cb
> ("caif-hsi: Add missing return in error path") from the net tree and
> commits 4e7bb59d49fb ("caif-hsi: Removed dead code") and c41254006377
> ("caif-hsi: Add rtnl support") from the net-next tree.
> 
> I fixed them up (see below) and can carry the fix as necessary.

Sorry for late response. Your merge looks perfect.

Thanks,
Sjur
