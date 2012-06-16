Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2FPTbi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:31:38 -0400
Received: from mx2.netapp.com ([216.240.18.37]:60259 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab2FPTbh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:31:37 -0400
X-IronPort-AV: E=Sophos;i="4.75,783,1330934400"; 
   d="scan'208";a="655865749"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "ksummit-2012-discuss@lists.linux-foundation.org" 
	<ksummit-2012-discuss@lists.linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [ATTEND] Discussion: role of the maintainer?
Thread-Topic: [ATTEND] Discussion: role of the maintainer?
Thread-Index: AQHNS/abOYKvrFmdEkm0pnWCMkPIXw==
Date: Sat, 16 Jun 2012 19:31:19 +0000
Message-ID: <1339875074.8267.87.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <29F803A70CE70849A8425DBC91799445@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5GJVhxL013053

Hi,

This is a spin off from the discussion topic that was started by Thomas
Gleixner. I'd like to turn this into a full discussion on the role of
the Linux Maintainer.

Currently, the Linux maintainer appears to be responsible for filling
all of the traditional roles of software architect, software developer,
patch reviewer, patch committer, and software maintainer.

My question is whether or not there might be some value in splitting out
some of these roles, so that we can assign them to different people, and
thus help to address the scalability issues that Thomas raised? For
instance, would it be useful to have a separate 'software maintainer'
role for dealing with post-merge issues, such as ensuring that bugs and
regressions get fixed by someone?
If so, how do we ensure that people get credit for the roles that they
assume? Should we perhaps add additional entries to the MAINTAINERS file
for some of these responsibilities?

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
