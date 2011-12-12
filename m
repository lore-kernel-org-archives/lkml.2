Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097Ab1LLHxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:53:14 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:48402 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751259Ab1LLHxM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:53:12 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 12 Dec 2011 08:52:43 +0100
Subject: RE: [PATCH -next] xshm: fix build errors, depends on NET
Thread-Topic: [PATCH -next] xshm: fix build errors, depends on NET
Thread-Index: Acy2uKR44uv0gqFsSzyKH0KQuE8sOQB6Yxkw
Message-ID: <81C3A93C17462B4BBD7E272753C105791FB0D6B96F@EXDCVYMBSTM005.EQ1STM.local>
References: <20111209163247.1de15dcb5b735ca5e1ad030b@canb.auug.org.au>
 <4EE289FE.90006@xenotime.net>
In-Reply-To: <4EE289FE.90006@xenotime.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Randy Dunlap <rdunlap@xenotime.net>
>
>Fix build errors in xshm.  xshm uses netlink, so it
>should depend on NET.
>
>ERROR: "genl_unregister_family" [drivers/xshm/xshm.ko] undefined!
>ERROR: "netlink_unicast" [drivers/xshm/xshm.ko] undefined!
>ERROR: "genl_register_family_with_ops" [drivers/xshm/xshm.ko] undefined!
>ERROR: "init_net" [drivers/xshm/xshm.ko] undefined!
>ERROR: "__alloc_skb" [drivers/xshm/xshm.ko] undefined!
>ERROR: "kfree_skb" [drivers/xshm/xshm.ko] undefined!
>ERROR: "skb_put" [drivers/xshm/xshm.ko] undefined!

Thank you Randy,
Acked-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

>Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
>Cc: Sjur Brendeland <sjur.brandeland@stericsson.com>
