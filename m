Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0FHIsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 04:48:51 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:16317 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753482Ab0FHIst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 04:48:49 -0400
Message-ID: <002e01cb06e7$69846f10$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C08D268.6000404@dsn.okisemi.com> <201006071537.27140.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 8 Jun 2010 17:48:40 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd

We are studying your indication.
> My feeling is that this ioctl interface is too
> low-level in general. You only export access to specific
> registers, not to functionality exposed by them.
> The best kernel interfaces are defined in a way that
> is independent of the underlying hardware and
> convert generic commands into device specific commands.

I have a question.
We don't know 'generic commands' concretely.
Let me know 'generic commands' in detail.

Thanks. Ohtake.

----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>; "Andrew" <andrew.chih.howe.khor@intel.com>; "Intel OTC"
<joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y" <yong.y.wang@intel.com>
Sent: Monday, June 07, 2010 10:37 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Friday 04 June 2010, Masayuki Ohtake wrote:
> > From: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
> >
> > This patch adds the Packet Hub driver for Topcliff.
> > Patch created against 2.6.33.1
> >
> > Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>
> Most of the comments from my first review still apply to
> this version, please have another look at what I wrote
> back in april, see http://article.gmane.org/gmane.linux.network/158879
>
> Note also that patch submissions should be against the latest
> development kernel, in this case 2.6.35-rc2, not against stable
> kernel releases like 2.6.33.1.
>
> Arnd
>


