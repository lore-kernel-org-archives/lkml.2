Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727Ab2FROx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:53:59 -0400
Received: from mx2.netapp.com ([216.240.18.37]:9077 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab2FROx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:53:58 -0400
X-IronPort-AV: E=Sophos;i="4.75,792,1330934400"; 
   d="scan'208";a="656175777"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3}
Thread-Topic: nfs3 problem with -rc{2,3}
Thread-Index: AQHNTMS9i2iatMLpKEGb4f4ZWuxoUpcAjD8AgAAA1ACAAAlRAIAACccA
Date: Mon, 18 Jun 2012 14:53:56 +0000
Message-ID: <1340031234.2451.13.camel@lade.trondhjem.org>
References: <20120617200700.GA15348@milliways>
	 <1340026956.2451.9.camel@lade.trondhjem.org>
	 <1340027134.2451.12.camel@lade.trondhjem.org>
	 <20120618141854.GA7962@milliways>
In-Reply-To: <20120618141854.GA7962@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E7DE5C36A2DC64185F4BFD7729738F0@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5IEs4ZF022011

On Mon, 2012-06-18 at 15:18 +0100, Ken Moffat wrote:
> On Mon, Jun 18, 2012 at 01:45:35PM +0000, Myklebust, Trond wrote:
> > > 
> > > Is this a problem with the client or with the server, and have you tried
> > > seeing if the fixes that were merged into -rc3 help?
> > 
> > Doh... Ignore the second half of the above sentence. error=ENOCOFFEE.
> > 
> > I would still like to know whether this is a client or server issue
> > (i.e. whether a downgrade of one or the other to 3.4 fixes the problem).
> 
>  It's the client - the server is still running 3.0.

OK. You said you had bisected this down to 15 patches? Can you please
tell me which ones?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
