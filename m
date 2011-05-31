Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1EaQUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 12:20:05 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:49092 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab1EaQUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 12:20:03 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 31 May 2011 17:20:02 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: <linux-kernel@vger.kernel.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
References: <20110523220536.GB11961@dumpdata.com>
 <756073831c36e0404199a4e8239bcb70@admin.gogi.tv>
 <m2wrhf4sw5.fsf@firstfloor.org>
 <08370791664f069624d25c757ed101c0@admin.gogi.tv>
 <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
Message-ID: <cf5f8577f464560818dc220baee674e8@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Why not fix it right the first time?
 
 I meant it only if the fix was trivial, like adding a few lines of
 sync_page calls. In that case maybe it could go into 3.0.0
 and those people with via chipsets or xen could have a working system.

 If there is no trivial fix then of course you are right.

