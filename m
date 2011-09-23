Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045Ab1IWR1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:27:11 -0400
Received: from mx2.netapp.com ([216.240.18.37]:17006 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981Ab1IWR1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:27:07 -0400
X-IronPort-AV: E=Sophos;i="4.68,431,1312182000"; 
   d="scan'208";a="584292070"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH v6 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Date: Fri, 23 Sep 2011 10:26:49 -0700
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430B54DB89@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4E7C9A91.1060301@parallels.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH v6 1/8] SUNRPC: introduce helpers for reference counted rpcbind clients
Thread-Index: Acx5/vFtCkjj9qZjTvmMtGpWEKwqQgAFt0ww
References: <20110920101031.9861.18444.stgit@localhost6.localdomain6> <20110920101341.9861.51453.stgit@localhost6.localdomain6> <4E7899E7.9090809@parallels.com> <4E79A95F.8050304@parallels.com> <4E7C9A91.1060301@parallels.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Stanislav Kinsbursky" <skinsbursky@parallels.com>
Cc: <linux-nfs@vger.kernel.org>, "Pavel Emelianov" <xemul@parallels.com>,
        <neilb@suse.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bfields@fieldses.org>,
        <davem@davemloft.net>
X-OriginalArrivalTime: 23 Sep 2011 17:26:50.0977 (UTC) FILETIME=[FAEEFD10:01CC7A15]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p8NHRKur006058

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Friday, September 23, 2011 10:41 AM
> To: Myklebust, Trond
> Cc: linux-nfs@vger.kernel.org; Pavel Emelianov; neilb@suse.de;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> bfields@fieldses.org; davem@davemloft.net
> Subject: Re: [PATCH v6 1/8] SUNRPC: introduce helpers for reference
> counted rpcbind clients
> 
> Trond, is this patch version suits you now? Or not?
> Please, comment somehow to let me know, may I proceed with further
> development or not.

Hi Stanislav,

Yes, this version of the patch looks safe to me.

Cheers
  Trond
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
